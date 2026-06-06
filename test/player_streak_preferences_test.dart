import 'package:flutter_test/flutter_test.dart';
import 'package:network_cable_demo/data/player_streak_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'records only one streak day for repeated lessons on the same day',
    () async {
      final preferences = PlayerStreakPreferences();
      final day = DateTime(2026, 6, 1);

      final first = await preferences.recordLessonCompleted(
        'kral@example.com',
        now: day,
      );
      final second = await preferences.recordLessonCompleted(
        'kral@example.com',
        now: day.add(const Duration(hours: 3)),
      );

      expect(first.currentStreak, 1);
      expect(second.currentStreak, 1);
      expect(second.longestStreak, 1);
      expect(second.activeDayKeys, hasLength(1));
    },
  );

  test(
    'extends the streak on consecutive days and resets after a gap',
    () async {
      final preferences = PlayerStreakPreferences();
      final day = DateTime(2026, 6, 1);

      await preferences.recordLessonCompleted('kral@example.com', now: day);
      final consecutive = await preferences.recordLessonCompleted(
        'kral@example.com',
        now: day.add(const Duration(days: 1)),
      );
      final afterGap = await preferences.recordLessonCompleted(
        'kral@example.com',
        now: day.add(const Duration(days: 3)),
      );

      expect(consecutive.currentStreak, 2);
      expect(consecutive.longestStreak, 2);
      expect(afterGap.currentStreak, 1);
      expect(afterGap.longestStreak, 2);
      expect(afterGap.activeDayKeys, hasLength(3));
    },
  );
}
