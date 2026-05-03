class Plant {
  String id;
  String name;
  int waterCount;
  int growthLevel;
  DateTime? lastWatered;
  DateTime? lastClaimed;
  DateTime createdAt;

  Plant({
    required this.id,
    required this.name,
    this.waterCount = 0,
    this.growthLevel = 1,
    this.lastWatered,
    this.lastClaimed,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isWilting {
    if (lastWatered == null) return true;
    return DateTime.now().difference(lastWatered!).inDays >= 2;
  }

  String get condition => isWilting ? 'Layu 🥀' : 'Sehat 🌿';

  bool get hasClaimedToday {
    if (lastClaimed == null) return false;
    final now = DateTime.now();
    return lastClaimed!.year == now.year &&
        lastClaimed!.month == now.month &&
        lastClaimed!.day == now.day;
  }

  void addWater(int amount) => waterCount += amount;

  bool water() {
    if (waterCount <= 0) return false;
    waterCount--;
    lastWatered = DateTime.now();
    if (waterCount >= 5 && growthLevel < 5) {
      growthLevel++;
      waterCount -= 5;
    }
    return true;
  }

  bool claimDailyWater() {
    if (hasClaimedToday) return false;
    waterCount++;
    lastClaimed = DateTime.now();
    return true;
  }

  String get stageName {
    switch (growthLevel) {
      case 1: return 'Benih 🌱';
      case 2: return 'Kecambah 🌿';
      case 3: return 'Tumbuh 🪴';
      case 4: return 'Berkembang 🌳';
      case 5: return 'Mekar 🌸';
      default: return 'Benih 🌱';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'waterCount': waterCount,
    'growthLevel': growthLevel,
    'lastWatered': lastWatered?.toIso8601String(),
    'lastClaimed': lastClaimed?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
    id: json['id'],
    name: json['name'],
    waterCount: json['waterCount'] ?? 0,
    growthLevel: json['growthLevel'] ?? 1,
    lastWatered: json['lastWatered'] != null
        ? DateTime.parse(json['lastWatered']) : null,
    lastClaimed: json['lastClaimed'] != null
        ? DateTime.parse(json['lastClaimed']) : null,
    createdAt: DateTime.parse(json['createdAt']),
  );
}