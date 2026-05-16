import 'package:flutter/material.dart';

enum TrackingType { glycemie, medicament, aliment }

class AppState {
  static final ValueNotifier<TrackingType> currentType = ValueNotifier<TrackingType>(TrackingType.glycemie);
  static final ValueNotifier<String> currentFilter = ValueNotifier<String>('Tous');
  static final ValueNotifier<String> globalUnit = ValueNotifier<String>('mg/dL'); // Unité globale
}