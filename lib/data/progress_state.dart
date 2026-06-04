import '../game/levels/level_data.dart';

class LevelProgress {
  const LevelProgress({
    required this.levelId,
    required this.unlocked,
    required this.completed,
    required this.attempts,
    required this.hintsUsed,
  });

  final String levelId;
  final bool unlocked;
  final bool completed;
  final int attempts;
  final int hintsUsed;

  LevelProgress copyWith({
    bool? unlocked,
    bool? completed,
    int? attempts,
    int? hintsUsed,
  }) {
    return LevelProgress(
      levelId: levelId,
      unlocked: unlocked ?? this.unlocked,
      completed: completed ?? this.completed,
      attempts: attempts ?? this.attempts,
      hintsUsed: hintsUsed ?? this.hintsUsed,
    );
  }
}

class ProgressSnapshot {
  const ProgressSnapshot({
    required this.levels,
    required this.lastPlayedLevelId,
  });

  final List<LevelProgress> levels;
  final String lastPlayedLevelId;

  LevelProgress progressFor(String levelId) {
    return levels.firstWhere((level) => level.levelId == levelId);
  }
}

class LevelProgressView {
  const LevelProgressView({required this.level, required this.progress});

  final LevelData level;
  final LevelProgress progress;
}
