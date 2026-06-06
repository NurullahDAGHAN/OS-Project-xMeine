import 'player_streak.dart';
import 'progress_state.dart';

enum PlayerTaskId {
  signIn,
  completeTwoLevels,
  completeFourLevels,
  completeAllLevels,
}

enum PlayerBadgeId { completeTwoTasks, completeFourTasks, completeAllLevels }

class PlayerTaskProgress {
  const PlayerTaskProgress({
    required this.id,
    required this.currentValue,
    required this.targetValue,
  });

  final PlayerTaskId id;
  final int currentValue;
  final int targetValue;

  bool get completed => currentValue >= targetValue;

  double get fraction {
    if (targetValue <= 0) {
      return 1;
    }
    final value = currentValue / targetValue;
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }
}

class PlayerBadgeProgress {
  const PlayerBadgeProgress({
    required this.id,
    required this.currentValue,
    required this.targetValue,
  });

  final PlayerBadgeId id;
  final int currentValue;
  final int targetValue;

  bool get unlocked => currentValue >= targetValue;
}

class PlayerProgressSummary {
  const PlayerProgressSummary({
    required this.userEmail,
    required this.signedIn,
    required this.completedLevels,
    required this.totalLevels,
    required this.streak,
  });

  factory PlayerProgressSummary.fromProgress({
    required ProgressSnapshot snapshot,
    required int totalLevels,
    String? userEmail,
    bool signedIn = true,
    PlayerStreak streak = const PlayerStreak.empty(),
  }) {
    return PlayerProgressSummary(
      userEmail: userEmail,
      signedIn: signedIn,
      completedLevels:
          snapshot.levels.where((progress) => progress.completed).length,
      totalLevels: totalLevels,
      streak: streak,
    );
  }

  final String? userEmail;
  final bool signedIn;
  final int completedLevels;
  final int totalLevels;
  final PlayerStreak streak;

  String get displayName {
    final email = userEmail?.trim();
    if (email == null || email.isEmpty) {
      return 'Oyuncu';
    }
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) {
      return email;
    }
    return email.substring(0, atIndex);
  }

  List<PlayerTaskProgress> get tasks {
    final allLevelsTarget = totalLevels <= 0 ? 1 : totalLevels;
    return [
      PlayerTaskProgress(
        id: PlayerTaskId.signIn,
        currentValue: signedIn ? 1 : 0,
        targetValue: 1,
      ),
      PlayerTaskProgress(
        id: PlayerTaskId.completeTwoLevels,
        currentValue: _capped(completedLevels, 2),
        targetValue: 2,
      ),
      PlayerTaskProgress(
        id: PlayerTaskId.completeFourLevels,
        currentValue: _capped(completedLevels, 4),
        targetValue: 4,
      ),
      PlayerTaskProgress(
        id: PlayerTaskId.completeAllLevels,
        currentValue: _capped(completedLevels, allLevelsTarget),
        targetValue: allLevelsTarget,
      ),
    ];
  }

  int get completedTasks => tasks.where((task) => task.completed).length;

  List<PlayerBadgeProgress> get badges {
    final count = completedTasks;
    final allLevelsTarget = totalLevels <= 0 ? 1 : totalLevels;
    return [
      PlayerBadgeProgress(
        id: PlayerBadgeId.completeTwoTasks,
        currentValue: _capped(count, 2),
        targetValue: 2,
      ),
      PlayerBadgeProgress(
        id: PlayerBadgeId.completeFourTasks,
        currentValue: _capped(count, 4),
        targetValue: 4,
      ),
      PlayerBadgeProgress(
        id: PlayerBadgeId.completeAllLevels,
        currentValue: _capped(completedLevels, allLevelsTarget),
        targetValue: allLevelsTarget,
      ),
    ];
  }

  int get unlockedBadges => badges.where((badge) => badge.unlocked).length;

  int get levelCompletionPercent {
    if (totalLevels <= 0) {
      return 0;
    }
    return ((completedLevels / totalLevels) * 100).round();
  }
}

int _capped(int value, int target) {
  if (value < 0) {
    return 0;
  }
  if (value > target) {
    return target;
  }
  return value;
}
