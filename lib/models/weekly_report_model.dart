import 'mood_model.dart';

class DailyMoodStat {
  final String dayName; // Sen, Sel, Rab, Kam, Jum, Sab, Min
  final DateTime date;
  final MoodType? mood;
  final bool hasEntry;

  DailyMoodStat({
    required this.dayName,
    required this.date,
    this.mood,
    required this.hasEntry,
  });
}

class WeeklyReport {
  final DateTime weekStartDate;
  final List<DailyMoodStat> dailyStats;
  final String consistencyLevel;
  final double consistencyPercentage;
  final MoodType? mostFrequentMood;

  WeeklyReport({
    required this.weekStartDate,
    required this.dailyStats,
    required this.consistencyLevel,
    required this.consistencyPercentage,
    this.mostFrequentMood,
  });
}
