import 'package:flutter/foundation.dart';

import 'auth_service.dart';
import 'progress_repository.dart';
import 'progress_state.dart';
import 'sqlite_progress_repository.dart';

Future<ProgressRepository> createProgressRepository() async {
  if (kIsWeb) {
    return _InMemoryProgressRepository();
  }
  final authService = AuthService();
  await authService.initialize();
  final userEmail = authService.getUserEmail();
  return SqliteProgressRepository(userEmail: userEmail);
}

class _InMemoryProgressRepository implements ProgressRepository {
  final Map<String, LevelProgress> _levels = {};
  String? _lastPlayedLevelId;

  @override
  Future<ProgressSnapshot> loadProgress(List<String> levelIds) async {
    _seedLevels(levelIds);
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> setLastPlayed(
    List<String> levelIds,
    String levelId,
  ) async {
    _seedLevels(levelIds);
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> recordHint(
    List<String> levelIds,
    String levelId,
  ) async {
    _seedLevels(levelIds);
    final current = _levels[levelId]!;
    _levels[levelId] = LevelProgress(
      levelId: levelId,
      unlocked: current.unlocked,
      completed: current.completed,
      attempts: current.attempts,
      hintsUsed: current.hintsUsed + 1,
    );
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> recordAttempt(
    List<String> levelIds,
    String levelId,
  ) async {
    _seedLevels(levelIds);
    final current = _levels[levelId]!;
    _levels[levelId] = LevelProgress(
      levelId: levelId,
      unlocked: current.unlocked,
      completed: current.completed,
      attempts: current.attempts + 1,
      hintsUsed: current.hintsUsed,
    );
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> completeLevel(
    List<String> levelIds,
    String levelId,
  ) async {
    _seedLevels(levelIds);
    final current = _levels[levelId]!;
    _levels[levelId] = LevelProgress(
      levelId: levelId,
      unlocked: true,
      completed: true,
      attempts: current.attempts,
      hintsUsed: current.hintsUsed,
    );

    final currentIndex = levelIds.indexOf(levelId);
    if (currentIndex >= 0 && currentIndex < levelIds.length - 1) {
      final nextLevelId = levelIds[currentIndex + 1];
      final next = _levels[nextLevelId]!;
      _levels[nextLevelId] = LevelProgress(
        levelId: nextLevelId,
        unlocked: true,
        completed: next.completed,
        attempts: next.attempts,
        hintsUsed: next.hintsUsed,
      );
    }
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  void _seedLevels(List<String> levelIds) {
    for (var i = 0; i < levelIds.length; i++) {
      final levelId = levelIds[i];
      if (!_levels.containsKey(levelId)) {
        _levels[levelId] = LevelProgress(
          levelId: levelId,
          unlocked: i == 0,
          completed: false,
          attempts: 0,
          hintsUsed: 0,
        );
      }
    }
    _unlockCompletedSequence(levelIds);
    if (_lastPlayedLevelId == null && levelIds.isNotEmpty) {
      _lastPlayedLevelId = levelIds.first;
    }
  }

  void _unlockCompletedSequence(List<String> levelIds) {
    for (var i = 0; i < levelIds.length - 1; i++) {
      final current = _levels[levelIds[i]];
      final next = _levels[levelIds[i + 1]];
      if ((current?.completed ?? false) && next != null && !next.unlocked) {
        _levels[next.levelId] = next.copyWith(unlocked: true);
      }
    }
  }

  ProgressSnapshot _snapshot(List<String> levelIds) {
    return ProgressSnapshot(
      levels: [
        for (final levelId in levelIds)
          _levels[levelId] ??
              LevelProgress(
                levelId: levelId,
                unlocked: levelId == levelIds.first,
                completed: false,
                attempts: 0,
                hintsUsed: 0,
              ),
      ],
      lastPlayedLevelId:
          _lastPlayedLevelId ?? (levelIds.isNotEmpty ? levelIds.first : ''),
    );
  }
}
