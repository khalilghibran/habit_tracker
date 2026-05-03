import 'package:flutter/foundation.dart';
import '../models/sleep_model.dart';

class SleepLogic extends ChangeNotifier {
  List<SleepEntry> _sleepHistory = [];
  SleepTarget _sleepTarget = SleepTarget(targetHours: 8.0, dateSet: DateTime.now());
  int _waterRewardCount = 0; // +1 Air reward counter
  SleepEntry? _todaySleep;

  List<SleepEntry> get sleepHistory => _sleepHistory;
  SleepTarget get sleepTarget => _sleepTarget;
  int get waterRewardCount => _waterRewardCount;
  SleepEntry? get todaySleep => _todaySleep;

  // Add a new sleep entry
  Future<SleepRewardResult> addSleepEntry(SleepEntry entry) async {
    final isMeetingTarget = entry.durationInHours >= _sleepTarget.targetHours;
    
    SleepEntry entryWithReward = SleepEntry(
      dateTime: entry.dateTime,
      durationInHours: entry.durationInHours,
      notes: entry.notes,
      rewardGiven: isMeetingTarget,
    );

    _sleepHistory.add(entryWithReward);

    // Check if this is today's entry
    if (_isToday(entry.dateTime)) {
      _todaySleep = entryWithReward;
    }

    // Award water if target is met
    if (isMeetingTarget) {
      _waterRewardCount += 1;
    }

    notifyListeners();

    return SleepRewardResult(
      isMeetingTarget: isMeetingTarget,
      rewardMessage: isMeetingTarget
          ? '+1 Air (reward)!'
          : 'Tidak dapat reward',
      waterRewardCount: _waterRewardCount,
    );
  }

  // Set sleep target in hours
  void setSleepTarget(double hours) {
    _sleepTarget = SleepTarget(targetHours: hours, dateSet: DateTime.now());
    notifyListeners();
  }

  // Get today's sleep duration
  SleepEntry? getTodaySleep() {
    final todays = _sleepHistory.where((entry) => _isToday(entry.dateTime));
    return todays.isEmpty ? null : todays.first;
  }

  // Get sleep history for a specific week
  List<SleepEntry> getWeeklySleepHistory(DateTime weekStartDate) {
    final weekEndDate = weekStartDate.add(Duration(days: 7, hours: 23, minutes: 59, seconds: 59));
    
    return _sleepHistory
        .where((entry) =>
            entry.dateTime.isAfter(weekStartDate) &&
            entry.dateTime.isBefore(weekEndDate))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Get sleep history for a specific month
  List<SleepEntry> getMonthlySleepHistory(int month, int year) {
    return _sleepHistory
        .where((entry) =>
            entry.dateTime.month == month && entry.dateTime.year == year)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Get all sleep history
  List<SleepEntry> getAllSleepHistory() {
    return _sleepHistory
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Get average sleep duration for the week
  double getWeeklyAverageSleep(DateTime weekStartDate) {
    final weekSleep = getWeeklySleepHistory(weekStartDate);
    if (weekSleep.isEmpty) return 0.0;
    
    final totalHours = weekSleep.fold<double>(
      0.0,
      (sum, entry) => sum + entry.durationInHours,
    );
    
    return totalHours / weekSleep.length;
  }

  // Get sleep quality status
  SleepQualityStatus getSleepQualityStatus(double durationInHours) {
    if (durationInHours >= _sleepTarget.targetHours) {
      return SleepQualityStatus.good;
    } else if (durationInHours >= _sleepTarget.targetHours - 2) {
      return SleepQualityStatus.fair;
    } else {
      return SleepQualityStatus.poor;
    }
  }

  // Get percentage of days meeting target in a period
  double getSleepCompliancePercentage(DateTime weekStartDate) {
    final weekSleep = getWeeklySleepHistory(weekStartDate);
    if (weekSleep.isEmpty) return 0.0;

    final metTargetCount = weekSleep
        .where((entry) => entry.durationInHours >= _sleepTarget.targetHours)
        .length;

    return (metTargetCount / weekSleep.length) * 100;
  }

  // Helper methods
  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  // Clear all sleep history
  void clearAllHistory() {
    _sleepHistory.clear();
    _waterRewardCount = 0;
    _todaySleep = null;
    notifyListeners();
  }

  // Delete a specific sleep entry
  void deleteSleepEntry(SleepEntry entry) {
    if (entry.rewardGiven) {
      _waterRewardCount = (_waterRewardCount - 1).clamp(0, double.infinity).toInt();
    }
    _sleepHistory.removeWhere(
      (e) => e.dateTime == entry.dateTime,
    );
    notifyListeners();
  }

  // Reset water reward counter
  void resetWaterRewardCounter() {
    _waterRewardCount = 0;
    notifyListeners();
  }
}

// Sleep quality enum
enum SleepQualityStatus {
  good,    // Met or exceeded target
  fair,    // Close to target (within 2 hours)
  poor,    // Far below target
}

// Result class for sleep entry with reward info
class SleepRewardResult {
  final bool isMeetingTarget;
  final String rewardMessage;
  final int waterRewardCount;

  SleepRewardResult({
    required this.isMeetingTarget,
    required this.rewardMessage,
    required this.waterRewardCount,
  });
}
