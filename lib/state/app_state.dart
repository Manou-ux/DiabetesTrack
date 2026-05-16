import 'package:flutter/material.dart';

enum TrackingType { glycemie, medicament, aliment }

class AppState {
  static final ValueNotifier<TrackingType> currentType = ValueNotifier<TrackingType>(TrackingType.glycemie);
  static final ValueNotifier<String> currentFilter = ValueNotifier<String>('Tous');
  static final ValueNotifier<String> globalUnit = ValueNotifier<String>('mg/dL'); // Unité globale

// --- NOUVEAU : INTERVALLES CIBLES MODIFIABLES (Valeurs par défaut en mg/dL) ---
  static final ValueNotifier<double> minNormal = ValueNotifier<double>(72.0);
  static final ValueNotifier<double> maxNormal = ValueNotifier<double>(99.0);
  static final ValueNotifier<double> maxPrediabetes = ValueNotifier<double>(126.0);

  // Fonction utilitaire pour calculer dynamiquement la catégorie d'une glycémie
  static String getCategory(double valueMgDl) {
    if (valueMgDl < minNormal.value) return 'Basse';
    if (valueMgDl >= minNormal.value && valueMgDl < maxNormal.value) return 'Normal';
    if (valueMgDl >= maxNormal.value && valueMgDl < maxPrediabetes.value) return 'Prédiabète';
    return 'Diabète';
  }
}