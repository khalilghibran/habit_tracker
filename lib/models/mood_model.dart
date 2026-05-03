enum MoodType { senang, baik, biasa, sedih, buruk }

class MoodEntry {
  final DateTime dateTime;
  final MoodType mood;
  final String? notes;

  MoodEntry({
    required this.dateTime,
    required this.mood,
    this.notes,
  });

  String getMoodEmoji() {
    switch (mood) {
      case MoodType.senang:
        return '😄';
      case MoodType.baik:
        return '😊';
      case MoodType.biasa:
        return '😐';
      case MoodType.sedih:
        return '😔';
      case MoodType.buruk:
        return '😢';
    }
  }

  String getMoodLabel() {
    switch (mood) {
      case MoodType.senang:
        return 'Senang';
      case MoodType.baik:
        return 'Baik';
      case MoodType.biasa:
        return 'Biasa';
      case MoodType.sedih:
        return 'Sedih';
      case MoodType.buruk:
        return 'Buruk';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'mood': mood.toString(),
      'notes': notes,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      dateTime: DateTime.parse(json['dateTime']),
      mood: MoodType.values.firstWhere(
        (e) => e.toString() == json['mood'],
      ),
      notes: json['notes'],
    );
  }
}

enum MoodResponseType { motivation, appreciation, neutral }

class MoodResponse {
  final MoodResponseType type;
  final String title;
  final String message;

  MoodResponse({
    required this.type,
    required this.title,
    required this.message,
  });

  String getIcon() {
    switch (type) {
      case MoodResponseType.motivation:
        return '💪';
      case MoodResponseType.appreciation:
        return '✨';
      case MoodResponseType.neutral:
        return '💭';
    }
  }
}
