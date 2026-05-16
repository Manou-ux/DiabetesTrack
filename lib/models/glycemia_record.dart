import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'glycemia_record.g.dart';

@HiveType(typeId: 0)
class GlycemiaRecord extends HiveObject {
  @HiveField(0)
  double value;

  @HiveField(1)
  String unit;

  @HiveField(2)
  String condition;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime dateTime;

  @HiveField(5)
  String type; // 'glycemie', 'medicament', 'aliment'

  GlycemiaRecord({
    required this.value,
    required this.unit,
    required this.condition,
    required this.category,
    required this.dateTime,
    required this.type,
  });

  // Légende dynamique selon l'unité
  static List<Map<String, dynamic>> getLegendForUnit(String unit) {
    if (unit.toLowerCase() == 'mmol/l') {
      return [
        {'name': 'Basse', 'range': '< 4.0', 'color': const Color(0xFF3B82F6)},
        {'name': 'Normal', 'range': '4.0 ~ 5.5', 'color': const Color(0xFF10B981)},
        {'name': 'Prédiabète', 'range': '5.5 ~ 7.0', 'color': const Color(0xFFF59E0B)},
        {'name': 'Diabète', 'range': '≥ 7.0', 'color': const Color(0xFFEF4444)},
      ];
    } else {
      return [
        {'name': 'Basse', 'range': '< 72', 'color': const Color(0xFF3B82F6)},
        {'name': 'Normal', 'range': '72 ~ 99', 'color': const Color(0xFF10B981)},
        {'name': 'Prédiabète', 'range': '99 ~ 126', 'color': const Color(0xFFF59E0B)},
        {'name': 'Diabète', 'range': '≥ 126', 'color': const Color(0xFFEF4444)},
      ];
    }
  }

  static String getCategoryFor({required double value, required String unit}) {
    double valMgDl = unit.toLowerCase() == 'mmol/l' ? value * 18.0182 : value;
    if (valMgDl < 72) return 'Basse';
    if (valMgDl >= 72 && valMgDl < 99) return 'Normal';
    if (valMgDl >= 99 && valMgDl < 126) return 'Prédiabète';
    return 'Diabète';
  }
}