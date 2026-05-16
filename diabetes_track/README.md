# 🩸 Diabetes Track

[![Flutter Version](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%E2%89%A53.0.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Database](https://img.shields.io/badge/Local%20DB-Hive-FF6F00?logo=hive&logoColor=white)](https://pub.dev/packages/hive)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-00ULL?style=flat)](https://github.com/votre_username)

**Diabetes Track** est une application multiplateforme moderne conçue pour simplifier le suivi quotidien des patients diabétiques. Elle permet d'enregistrer et de catégoriser précisément la glycémie, la prise de médicaments (insuline) et l'alimentation, tout en offrant des visualisations graphiques avancées et un filtrage dynamique pour analyser l'évolution de la santé.

---

## 📱 Aperçu de l'Application

L'interface utilisateur adopte un thème sombre élégant et minimaliste, optimisé pour réduire la fatigue visuelle lors des saisies quotidiennes :

* **Tableau de Bord interactif** : Suivi en temps réel avec des graphiques dynamiques selon l'unité choisie (`mg/dL` ou `mmol/L`).
* **Historique Global Filtrable** : Une vue chronologique segmentée par des puces de filtrage rapides et des codes couleurs normalisés.
* **Gestion Autonome (Offline First)** : Sauvegarde instantanée sans latence ni besoin d'une connexion internet constante.

---

## 🛠️ Stack Technique & Bibliothèques

L'application repose sur un écosystème robuste et performant :

* **Framework Principal** : [Flutter](https://flutter.dev) & **Dart** — Pour une interface fluide, native et réactive.
* **Base de Données Locale** : [Hive](https://pub.dev/packages/hive) (`hive_flutter`) — Base de données NoSQL ultra-rapide clé-valeur, idéale pour un fonctionnement *offline-first* fluide et sécurisé.
* **Visualisation Graphique** : [FL Chart](https://pub.dev/packages/fl_chart) — Pour le rendu des courbes et des rapports d'analyses glycémiques.
* **Formatage & Localisation** : [Intl](https://pub.dev/packages/intl) — Gestion complète de la régionalisation (dates, heures, nombres) configurée nativement en Français.
* **Routage Externe** : [Url Launcher](https://pub.dev/packages/url_launcher) — Intégration de modules interactifs permettant d'ouvrir directement les profils de contact et réseaux sociaux du développeur depuis les paramètres.

---

## 📁 Structure du Dépôt

Le projet est organisé de la manière suivante :

```text
├── APK/
│   └── app-release.apk       <-- Fichier exécutable prêt à installer sur Android
└── diabetes_track/           <-- Code source complet du projet Flutter
    ├── lib/
    │   ├── models/           # Modèles de données (GlycemiaRecord)
    │   ├── screens/          # Vues principales (Suivi, Historique, Paramètres...)
    │   ├── state/            # Gestion globale de l'état (AppState)
    │   └── main.dart         # Point d'entrée de l'application
    ├── pubspec.yaml          # Dépendances du projet
    └── ...
