import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'progress_repository.dart';
import 'progress_state.dart';

class SqliteProgressRepository implements ProgressRepository {
  SqliteProgressRepository({
    Future<Database> Function()? openDatabaseOverride,
    this.userEmail,
  })
    : _openDatabaseOverride = openDatabaseOverride;

  final Future<Database> Function()? _openDatabaseOverride;
  final String? userEmail;
  Database? _database;

  Future<Database> get _db async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }

    final opened =
        _openDatabaseOverride != null
            ? await _openDatabaseOverride()
            : await _openAppDatabase();
    _database = opened;
    return opened;
  }

  Future<void> close() async {
    final existing = _database;
    _database = null;
    await existing?.close();
  }

  @override
  Future<ProgressSnapshot> loadProgress(List<String> levelIds) async {
    final db = await _db;
    await _seedLevels(db, levelIds);
    return _snapshot(db, levelIds);
  }

  @override
  Future<ProgressSnapshot> setLastPlayed(
    List<String> levelIds,
    String levelId,
  ) async {
    final db = await _db;
    await _seedLevels(db, levelIds);
    await _setLastPlayed(db, levelId);
    return _snapshot(db, levelIds);
  }

  @override
  Future<ProgressSnapshot> recordHint(List<String> levelIds, String levelId) {
    return _increment(levelIds, levelId, 'hints_used');
  }

  @override
  Future<ProgressSnapshot> recordAttempt(
    List<String> levelIds,
    String levelId,
  ) {
    return _increment(levelIds, levelId, 'attempts');
  }

  @override
  Future<ProgressSnapshot> completeLevel(
    List<String> levelIds,
    String levelId,
  ) async {
    final db = await _db;
    await _seedLevels(db, levelIds);
    await db.transaction((txn) async {
      await txn.update(
        'level_progress',
        {'completed': 1, 'unlocked': 1},
        where: 'level_id = ? AND user_email = ?',
        whereArgs: [levelId, userEmail ?? ''],
      );

      final currentIndex = levelIds.indexOf(levelId);
      if (currentIndex >= 0 && currentIndex < levelIds.length - 1) {
        await txn.update(
          'level_progress',
          {'unlocked': 1},
          where: 'level_id = ? AND user_email = ?',
          whereArgs: [levelIds[currentIndex + 1], userEmail ?? ''],
        );
      }

      await _setLastPlayed(txn, levelId);
    });
    return _snapshot(db, levelIds);
  }

  Future<ProgressSnapshot> _increment(
    List<String> levelIds,
    String levelId,
    String column,
  ) async {
    final db = await _db;
    await _seedLevels(db, levelIds);
    await db.rawUpdate(
      'UPDATE level_progress SET $column = $column + 1 WHERE level_id = ? AND user_email = ?',
      [levelId, userEmail ?? ''],
    );
    await _setLastPlayed(db, levelId);
    return _snapshot(db, levelIds);
  }

  static Future<Database> _openAppDatabase() async {
    final databasePath = await getDatabasesPath();
    return openDatabase(
      path.join(databasePath, 'network_training.db'),
      version: 1,
      onCreate: (db, _) => createSchema(db),
    );
  }

  static Future<void> createSchema(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE level_progress (
        level_id TEXT NOT NULL,
        user_email TEXT NOT NULL,
        unlocked INTEGER NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        attempts INTEGER NOT NULL DEFAULT 0,
        hints_used INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (level_id, user_email)
      )
    ''');
    await db.execute('''
      CREATE TABLE app_state (
        key TEXT NOT NULL,
        user_email TEXT NOT NULL,
        value TEXT NOT NULL,
        PRIMARY KEY (key, user_email)
      )
    ''');
  }

  Future<void> _seedLevels(Database db, List<String> levelIds) async {
    await db.transaction((txn) async {
      for (var i = 0; i < levelIds.length; i++) {
        await txn.insert('level_progress', {
          'level_id': levelIds[i],
          'user_email': userEmail ?? '',
          'unlocked': i == 0 ? 1 : 0,
          'completed': 0,
          'attempts': 0,
          'hints_used': 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      final appState = await txn.query(
        'app_state',
        where: 'key = ? AND user_email = ?',
        whereArgs: ['last_played_level_id', userEmail ?? ''],
        limit: 1,
      );
      if (appState.isEmpty && levelIds.isNotEmpty) {
        await _setLastPlayed(txn, levelIds.first);
      }

      await _unlockCompletedSequence(txn, levelIds);
    });
  }

  Future<void> _unlockCompletedSequence(
    DatabaseExecutor db,
    List<String> levelIds,
  ) async {
    for (var i = 0; i < levelIds.length - 1; i++) {
      final currentRows = await db.query(
        'level_progress',
        columns: ['completed'],
        where: 'level_id = ? AND user_email = ?',
        whereArgs: [levelIds[i], userEmail ?? ''],
        limit: 1,
      );
      final currentCompleted =
          currentRows.isNotEmpty &&
          (currentRows.first['completed']! as int) == 1;
      if (!currentCompleted) {
        continue;
      }

      await db.update(
        'level_progress',
        {'unlocked': 1},
        where: 'level_id = ? AND user_email = ?',
        whereArgs: [levelIds[i + 1], userEmail ?? ''],
      );
    }
  }

  Future<ProgressSnapshot> _snapshot(
    DatabaseExecutor db,
    List<String> levelIds,
  ) async {
    final rows = await db.query(
      'level_progress',
      where: 'user_email = ?',
      whereArgs: [userEmail ?? ''],
    );
    final byId = {
      for (final row in rows)
        row['level_id']! as String: LevelProgress(
          levelId: row['level_id']! as String,
          unlocked: (row['unlocked']! as int) == 1,
          completed: (row['completed']! as int) == 1,
          attempts: row['attempts']! as int,
          hintsUsed: row['hints_used']! as int,
        ),
    };
    final stateRows = await db.query(
      'app_state',
      where: 'key = ? AND user_email = ?',
      whereArgs: ['last_played_level_id', userEmail ?? ''],
      limit: 1,
    );
    final lastPlayedLevelId =
        stateRows.isEmpty
            ? levelIds.first
            : stateRows.first['value']! as String;

    return ProgressSnapshot(
      levels: [
        for (final levelId in levelIds)
          byId[levelId] ??
              LevelProgress(
                levelId: levelId,
                unlocked: levelId == levelIds.first,
                completed: false,
                attempts: 0,
                hintsUsed: 0,
              ),
      ],
      lastPlayedLevelId: lastPlayedLevelId,
    );
  }

  Future<void> _setLastPlayed(DatabaseExecutor db, String levelId) async {
    await db.insert('app_state', {
      'key': 'last_played_level_id',
      'user_email': userEmail ?? '',
      'value': levelId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
