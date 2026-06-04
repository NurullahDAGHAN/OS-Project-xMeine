import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/data/sqlite_progress_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('seeds first level unlocked and keeps the rest locked', () async {
    final repository = _repository();

    final snapshot = await repository.loadProgress([
      'ethernet_connection',
      'ip_address',
      'default_gateway',
    ]);

    expect(snapshot.progressFor('ethernet_connection').unlocked, isTrue);
    expect(snapshot.progressFor('ip_address').unlocked, isFalse);
    expect(snapshot.progressFor('default_gateway').unlocked, isFalse);
    expect(snapshot.lastPlayedLevelId, 'ethernet_connection');

    await repository.close();
  });

  test('records completion, unlocks next level, attempts, and hints', () async {
    final repository = _repository();
    final ids = ['ethernet_connection', 'ip_address', 'default_gateway'];

    await repository.recordAttempt(ids, 'ethernet_connection');
    await repository.recordHint(ids, 'ethernet_connection');
    final completed = await repository.completeLevel(
      ids,
      'ethernet_connection',
    );

    final first = completed.progressFor('ethernet_connection');
    final second = completed.progressFor('ip_address');

    expect(first.completed, isTrue);
    expect(first.attempts, 1);
    expect(first.hintsUsed, 1);
    expect(second.unlocked, isTrue);
    expect(completed.lastPlayedLevelId, 'ethernet_connection');

    await repository.close();
  });

  test('unlocks appended levels when previous level is already complete', () async {
    final repository = _repository();
    final oldIds = ['ethernet_connection', 'ip_address'];

    await repository.completeLevel(oldIds, 'ethernet_connection');
    await repository.completeLevel(oldIds, 'ip_address');

    final expanded = await repository.loadProgress([
      'ethernet_connection',
      'ip_address',
      'subnet_mask',
    ]);

    expect(expanded.progressFor('subnet_mask').unlocked, isTrue);

    await repository.close();
  });
}

SqliteProgressRepository _repository() {
  return SqliteProgressRepository(
    openDatabaseOverride: () {
      return openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, _) => SqliteProgressRepository.createSchema(db),
      );
    },
  );
}
