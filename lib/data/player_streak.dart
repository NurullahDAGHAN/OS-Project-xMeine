class PlayerStreak {
  const PlayerStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastLessonDateKey,
    required this.activeDayKeys,
  });

  const PlayerStreak.empty()
    : currentStreak = 0,
      longestStreak = 0,
      lastLessonDateKey = null,
      activeDayKeys = const [];

  final int currentStreak;
  final int longestStreak;
  final String? lastLessonDateKey;
  final List<String> activeDayKeys;

  bool hasActivityOn(DateTime date) {
    return activeDayKeys.contains(streakDateKey(date));
  }

  bool get hasActivityToday {
    return lastLessonDateKey == streakDateKey(DateTime.now());
  }
}

String streakDateKey(DateTime date) {
  final local = DateTime(date.year, date.month, date.day);
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}
