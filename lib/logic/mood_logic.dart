import 'package:flutter/foundation.dart';
import '../models/mood_model.dart';

class MoodLogic extends ChangeNotifier {
  List<MoodEntry> _moodHistory = [];
  WeeklyReport? _weeklyReport;
  MoodEntry? _todayMood;

  List<MoodEntry> get moodHistory => _moodHistory;
  WeeklyReport? get weeklyReport => _weeklyReport;
  MoodEntry? get todayMood => _todayMood;

  // Add a new mood entry
  Future<void> addMoodEntry(MoodEntry entry) async {
    _moodHistory.add(entry);
    
    // Check if this is today's entry
    if (_isToday(entry.dateTime)) {
      _todayMood = entry;
    }
    
    // Update weekly report
    await updateWeeklyReport();
    notifyListeners();
  }

  // Update weekly report for the current week
  Future<void> updateWeeklyReport() async {
    final now = DateTime.now();
    final weekStartDate = _getWeekStartDate(now);
    // weekEndDate not used; week runs from weekStartDate through +6 days

    List<DailyMoodStat> dailyStats = [];
    Map<MoodType, int> moodCount = {};

    // Generate daily stats for the entire week
    for (int i = 0; i < 7; i++) {
      final currentDate = weekStartDate.add(Duration(days: i));
      final dayName = _getDayName(currentDate);

      // Find mood entry for this day
      final moodEntry = _moodHistory.firstWhere(
        (entry) => _isSameDay(entry.dateTime, currentDate),
        orElse: () => MoodEntry(
          dateTime: currentDate,
          mood: MoodType.biasa,
        ),
      );

      final hasEntry = _moodHistory.any(
        (entry) => _isSameDay(entry.dateTime, currentDate),
      );

      if (hasEntry) {
        moodCount[moodEntry.mood] = (moodCount[moodEntry.mood] ?? 0) + 1;
      }

      dailyStats.add(
        DailyMoodStat(
          dayName: dayName,
          date: currentDate,
          mood: moodEntry.mood,
          hasEntry: hasEntry,
        ),
      );
    }

    // Calculate consistency
    final entriesThisWeek = dailyStats.where((s) => s.hasEntry).length;
    final consistencyPercentage = (entriesThisWeek / 7) * 100;
    final consistencyLevel = _getConsistencyLevel(consistencyPercentage);

    // Find most frequent mood
    MoodType? mostFrequentMood;
    if (moodCount.isNotEmpty) {
      mostFrequentMood = moodCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    _weeklyReport = WeeklyReport(
      weekStartDate: weekStartDate,
      dailyStats: dailyStats,
      consistencyLevel: consistencyLevel,
      consistencyPercentage: consistencyPercentage,
      mostFrequentMood: mostFrequentMood,
    );

    notifyListeners();
  }

  // Get mood history for a specific week
  List<MoodEntry> getWeeklyMoodHistory(DateTime weekStartDate) {
    final weekEndDate = weekStartDate.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    
    return _moodHistory
        .where((entry) =>
            entry.dateTime.isAfter(weekStartDate) &&
            entry.dateTime.isBefore(weekEndDate))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Get mood history for the current month
  List<MoodEntry> getMonthlyMoodHistory(int month, int year) {
    return _moodHistory
        .where((entry) =>
            entry.dateTime.month == month && entry.dateTime.year == year)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Get all mood history sorted by most recent
  List<MoodEntry> getAllMoodHistory() {
    return _moodHistory
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Helper methods
  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime _getWeekStartDate(DateTime date) {
    // Get Monday of the current week
    final daysToSubtract = date.weekday - 1;
    return date.subtract(Duration(days: daysToSubtract));
  }

  String _getDayName(DateTime date) {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return names[date.weekday - 1];
  }

  String _getConsistencyLevel(double percentage) {
    if (percentage >= 80) return 'HIGH';
    if (percentage >= 50) return 'MEDIUM';
    return 'LOW';
  }

  // Clear all mood history
  void clearAllHistory() {
    _moodHistory.clear();
    _weeklyReport = null;
    _todayMood = null;
    notifyListeners();
  }

  // Delete a specific mood entry
  void deleteMoodEntry(MoodEntry entry) {
    _moodHistory.removeWhere(
      (e) => e.dateTime == entry.dateTime && e.mood == entry.mood,
    );
    updateWeeklyReport();
  }

  // Check if mood is positive or negative
  bool isMoodPositive(MoodType mood) {
    return mood == MoodType.senang || mood == MoodType.baik;
  }

  bool isMoodNegative(MoodType mood) {
    return mood == MoodType.sedih || mood == MoodType.buruk;
  }

  // Get response based on mood
  MoodResponse getMoodResponse(MoodType mood) {
    if (isMoodPositive(mood)) {
      return MoodResponse(
        type: MoodResponseType.appreciation,
        title: 'Apresiasi',
        message: _getAppreciationMessage(mood),
      );
    } else if (isMoodNegative(mood)) {
      return MoodResponse(
        type: MoodResponseType.motivation,
        title: 'Motivasi',
        message: _getMotivationMessage(mood),
      );
    } else {
      return MoodResponse(
        type: MoodResponseType.neutral,
        title: 'Catatan',
        message: 'Hari ini adalah hari yang biasa. Ambil waktu untuk diri sendiri!',
      );
    }
  }

  // Get motivation messages for negative moods
  String _getMotivationMessage(MoodType mood) {
    final messages = {
      MoodType.sedih: [
        'Sedih adalah bagian dari hidup. Hal ini akan berlalu. 💪',
        'Ambil napas dalam dan ingat hal-hal yang membuat Anda tersenyum. 😊',
        'Setiap hari adalah kesempatan baru untuk memulai lagi.',
        'Anda lebih kuat dari yang Anda pikirkan. Percayalah pada diri sendiri!',
      ],
      MoodType.buruk: [
        'Waktu yang sulit tidak berlangsung selamanya. Ini akan membaik! 🌟',
        'Hubungi seseorang yang Anda sayangi. Mereka ingin membantu.',
        'Segala sesuatu yang indah dimulai dengan langkah kecil.',
        'Anda layak untuk kebahagiaan dan kedamaian pikiran.',
      ],
    };

    final moodMessages = messages[mood] ?? [];
    return moodMessages.isNotEmpty 
        ? moodMessages[DateTime.now().hashCode % moodMessages.length]
        : 'Anda bisa melewati ini!';
  }

  // Get appreciation messages for positive moods
  String _getAppreciationMessage(MoodType mood) {
    final messages = {
      MoodType.senang: [
        'Senang mendengar Anda tersenyum! Nikmati momen ini! 😄',
        'Kebahagiaan Anda menginspirasi orang-orang di sekitar Anda!',
        'Terus pertahankan semangat positif ini! ✨',
        'Hari ini adalah hari yang menakjubkan berkat Anda!',
      ],
      MoodType.baik: [
        'Hebat! Anda memiliki energi positif hari ini! 😊',
        'Pertahankan momentum ini. Anda melakukan pekerjaan yang luar biasa!',
        'Suasana hati yang baik adalah awal dari hari yang lebih baik!',
        'Terima kasih telah berbagi kebahagiaan Anda dengan dunia.',
      ],
    };

    final moodMessages = messages[mood] ?? [];
    return moodMessages.isNotEmpty 
        ? moodMessages[DateTime.now().hashCode % moodMessages.length]
        : 'Terus pertahankan semangat positif Anda!';
  }
}
