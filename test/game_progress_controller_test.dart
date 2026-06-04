import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/data/game_progress_controller.dart';
import 'package:network_cable_demo/data/level_repository.dart';
import 'package:network_cable_demo/data/progress_repository.dart';
import 'package:network_cable_demo/data/progress_state.dart';
import 'package:network_cable_demo/game/levels/levels.dart';

void main() {
  test(
    'keeps locked levels unselectable until completion unlocks them',
    () async {
      final repository = _MemoryProgressRepository();
      final controller = GameProgressController(
        levelRepository: const DartLevelRepository(),
        progressRepository: repository,
      );

      await controller.initialize();
      expect(controller.selectedLevel.id, levels.first.id);

      await controller.selectLevel(levels[1].id);
      expect(controller.selectedLevel.id, levels.first.id);

      await controller.completeSelectedLevel();
      expect(controller.levelViews[1].progress.unlocked, isTrue);

      await controller.selectNextLevel();
      expect(controller.selectedLevel.id, levels[1].id);
    },
  );

  test('records attempts and hints through the repository', () async {
    final repository = _MemoryProgressRepository();
    final controller = GameProgressController(
      levelRepository: const DartLevelRepository(),
      progressRepository: repository,
    );

    await controller.initialize();
    await controller.recordAttempt();
    await controller.recordHint();

    final progress = controller.snapshot!.progressFor(levels.first.id);
    expect(progress.attempts, 1);
    expect(progress.hintsUsed, 1);
  });
}

class _MemoryProgressRepository implements ProgressRepository {
  final Map<String, LevelProgress> _progress = {};
  String? _lastPlayedLevelId;

  @override
  Future<ProgressSnapshot> loadProgress(List<String> levelIds) async {
    _seed(levelIds);
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> setLastPlayed(
    List<String> levelIds,
    String levelId,
  ) async {
    _seed(levelIds);
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> recordAttempt(
    List<String> levelIds,
    String levelId,
  ) async {
    _seed(levelIds);
    final current = _progress[levelId]!;
    _progress[levelId] = current.copyWith(attempts: current.attempts + 1);
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> recordHint(
    List<String> levelIds,
    String levelId,
  ) async {
    _seed(levelIds);
    final current = _progress[levelId]!;
    _progress[levelId] = current.copyWith(hintsUsed: current.hintsUsed + 1);
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  @override
  Future<ProgressSnapshot> completeLevel(
    List<String> levelIds,
    String levelId,
  ) async {
    _seed(levelIds);
    final current = _progress[levelId]!;
    _progress[levelId] = current.copyWith(completed: true, unlocked: true);
    final nextIndex = levelIds.indexOf(levelId) + 1;
    if (nextIndex > 0 && nextIndex < levelIds.length) {
      final next = _progress[levelIds[nextIndex]]!;
      _progress[levelIds[nextIndex]] = next.copyWith(unlocked: true);
    }
    _lastPlayedLevelId = levelId;
    return _snapshot(levelIds);
  }

  void _seed(List<String> levelIds) {
    for (var i = 0; i < levelIds.length; i++) {
      _progress.putIfAbsent(
        levelIds[i],
        () => LevelProgress(
          levelId: levelIds[i],
          unlocked: i == 0,
          completed: false,
          attempts: 0,
          hintsUsed: 0,
        ),
      );
    }
    _lastPlayedLevelId ??= levelIds.first;
  }

  ProgressSnapshot _snapshot(List<String> levelIds) {
    return ProgressSnapshot(
      levels: [for (final id in levelIds) _progress[id]!],
      lastPlayedLevelId: _lastPlayedLevelId!,
    );
  }
}
