import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/models/plant_model.dart';

class PlantLogic {
  static const String _key = 'plant_data';

  static Future<Plant> loadPlant() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) {
      return Plant(id: 'plant_1', name: 'Tanaman Kecilku');
    }
    return Plant.fromJson(jsonDecode(data));
  }

  static Future<void> savePlant(Plant plant) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(plant.toJson()));
  }

  static Future<bool> claimDailyWater() async {
    final plant = await loadPlant();
    final success = plant.claimDailyWater();
    if (success) await savePlant(plant);
    return success;
  }

  static Future<bool> waterPlant() async {
    final plant = await loadPlant();
    final success = plant.water();
    if (success) await savePlant(plant);
    return success;
  }

  static Future<void> addWaterReward(int amount) async {
    final plant = await loadPlant();
    plant.addWater(amount);
    await savePlant(plant);
  }

  static Future<Map<String, dynamic>> getPlantInfo() async {
    final plant = await loadPlant();
    return {
      'name': plant.name,
      'waterCount': plant.waterCount,
      'growthLevel': plant.growthLevel,
      'progress': plant.progress,
      'stageName': plant.stageName,
      'condition': plant.condition,
      'isWilting': plant.isWilting,
      'hasClaimedToday': plant.hasClaimedToday,
    };
  }
}