import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/game/levels/levels.dart';

void main() {
  test('all levels define scene objects and connection data', () {
    for (final level in levels) {
      expect(level.objects, isNotEmpty, reason: level.id);
      expect(level.connectionGoal.cableId, isNotEmpty, reason: level.id);
      expect(level.connectionGoal.fromObjectId, isNotEmpty, reason: level.id);
      expect(level.connectionGoal.toObjectId, isNotEmpty, reason: level.id);
    }
  });

  test('selection levels use a generic selection goal', () {
    final selectionLevels = levels.where((level) => level.usesOptionSelection);

    expect(selectionLevels.length, levels.length - 1);
    for (final level in selectionLevels) {
      final goal = level.selectionGoal;

      expect(goal.question, isNotEmpty, reason: level.id);
      expect(
        goal.options,
        hasLength(greaterThanOrEqualTo(2)),
        reason: level.id,
      );
      expect(goal.options, contains(goal.correctOption), reason: level.id);
    }
  });

  test('learning notes are separate from character prompts', () {
    for (final level in levels) {
      expect(level.learningNote, isNotEmpty, reason: level.id);
      expect(level.learningNote, isNot(level.dialogue), reason: level.id);
      expect(level.learningNote, isNot(level.hintMessage), reason: level.id);
    }
  });
}
