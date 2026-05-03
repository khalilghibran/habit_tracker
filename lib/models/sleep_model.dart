class SleepEntry {
  final DateTime dateTime;
  final double durationInHours; // Sleep duration in hours
  final String? notes;
  final bool rewardGiven;

  SleepEntry({
    required this.dateTime,
    required this.durationInHours,
    this.notes,
    this.rewardGiven = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'durationInHours': durationInHours,
      'notes': notes,
      'rewardGiven': rewardGiven,
    };
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      dateTime: DateTime.parse(json['dateTime']),
      durationInHours: json['durationInHours'],
      notes: json['notes'],
      rewardGiven: json['rewardGiven'] ?? false,
    );
  }
}

class SleepTarget {
  final double targetHours; // Recommended sleep hours
  final DateTime dateSet;

  SleepTarget({
    required this.targetHours,
    required this.dateSet,
  });
}
