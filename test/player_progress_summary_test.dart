import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/data/player_progress_summary.dart';
import 'package:network_cable_demo/data/progress_state.dart';

void main() {
  test('counts sign-in as the first completed task', () {
    final summary = PlayerProgressSummary.fromProgress(
      userEmail: 'kral@example.com',
      snapshot: _snapshot(completedCount: 0, totalCount: 7),
      totalLevels: 7,
    );

    expect(summary.displayName, 'kral');
    expect(summary.completedLevels, 0);
    expect(summary.completedTasks, 1);
    expect(summary.badges.first.unlocked, isFalse);
  });

  test('unlocks the two-task badge after two completed levels', () {
    final summary = PlayerProgressSummary.fromProgress(
      snapshot: _snapshot(completedCount: 2, totalCount: 7),
      totalLevels: 7,
    );

    expect(summary.completedTasks, 2);
    expect(summary.badges[0].id, PlayerBadgeId.completeTwoTasks);
    expect(summary.badges[0].unlocked, isTrue);
    expect(summary.badges[1].unlocked, isFalse);
    expect(summary.badges[2].id, PlayerBadgeId.completeAllLevels);
    expect(summary.badges[2].unlocked, isFalse);
  });

  test('unlocks all task badges after every level is complete', () {
    final summary = PlayerProgressSummary.fromProgress(
      snapshot: _snapshot(completedCount: 7, totalCount: 7),
      totalLevels: 7,
    );

    expect(summary.completedTasks, 4);
    expect(summary.unlockedBadges, 3);
    expect(summary.tasks.last.id, PlayerTaskId.completeAllLevels);
    expect(summary.tasks.last.completed, isTrue);
    expect(summary.badges.last.id, PlayerBadgeId.completeAllLevels);
    expect(summary.badges.last.unlocked, isTrue);
  });
}

ProgressSnapshot _snapshot({
  required int completedCount,
  required int totalCount,
}) {
  return ProgressSnapshot(
    levels: [
      for (var i = 0; i < totalCount; i++)
        LevelProgress(
          levelId: 'level_$i',
          unlocked: i == 0 || i <= completedCount,
          completed: i < completedCount,
          attempts: 0,
          hintsUsed: 0,
        ),
    ],
    lastPlayedLevelId: 'level_0',
  );
}
