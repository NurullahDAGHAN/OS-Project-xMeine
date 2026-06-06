import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

import 'player_streak.dart';

class PlayerStreakPreferences {
  static const String _currentPrefix = 'player_streak_current';
  static const String _longestPrefix = 'player_streak_longest';
  static const String _lastDayPrefix = 'player_streak_last_day';
  static const String _activeDaysPrefix = 'player_streak_active_days';

  Future<PlayerStreak> load(String? userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final suffix = _userSuffix(userEmail);
    return PlayerStreak(
      currentStreak: prefs.getInt('$_currentPrefix$suffix') ?? 0,
      longestStreak: prefs.getInt('$_longestPrefix$suffix') ?? 0,
      lastLessonDateKey: prefs.getString('$_lastDayPrefix$suffix'),
      activeDayKeys:
          prefs.getStringList('$_activeDaysPrefix$suffix') ?? const [],
    );
  }

  Future<PlayerStreak> recordLessonCompleted(
    String? userEmail, {
    DateTime? now,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final suffix = _userSuffix(userEmail);
    final currentKey = '$_currentPrefix$suffix';
    final longestKey = '$_longestPrefix$suffix';
    final lastDayKey = '$_lastDayPrefix$suffix';
    final activeDaysKey = '$_activeDaysPrefix$suffix';
    final today = now ?? DateTime.now();
    final todayKey = streakDateKey(today);
    final lastLessonDateKey = prefs.getString(lastDayKey);
    final activeDays = prefs.getStringList(activeDaysKey) ?? <String>[];

    if (lastLessonDateKey == todayKey) {
      return load(userEmail);
    }

    final yesterdayKey = streakDateKey(today.subtract(const Duration(days: 1)));
    final currentStreak = prefs.getInt(currentKey) ?? 0;
    final nextStreak =
        lastLessonDateKey == yesterdayKey ? currentStreak + 1 : 1;
    final nextLongest = math.max(prefs.getInt(longestKey) ?? 0, nextStreak);

    if (!activeDays.contains(todayKey)) {
      activeDays.add(todayKey);
      activeDays.sort();
    }

    await prefs.setInt(currentKey, nextStreak);
    await prefs.setInt(longestKey, nextLongest);
    await prefs.setString(lastDayKey, todayKey);
    await prefs.setStringList(activeDaysKey, activeDays);

    return PlayerStreak(
      currentStreak: nextStreak,
      longestStreak: nextLongest,
      lastLessonDateKey: todayKey,
      activeDayKeys: activeDays,
    );
  }

  String _userSuffix(String? userEmail) {
    final normalized = userEmail?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return '_guest';
    }
    return '_$normalized';
  }
}
