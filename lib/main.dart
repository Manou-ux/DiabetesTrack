import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- 1. AJOUTE CET IMPORT
import 'models/glycemia_record.dart';
import 'screens/main_screen.dart';

void main() async {
  // Garantit que les services Flutter sont prêts
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. INITIALISE LES DONNÉES DE LOCALISATION (FRANÇAIS, ETC.)
  await initializeDateFormatting('fr', null);

  // Initialisation de Hive
  await Hive.initFlutter();
  Hive.registerAdapter(GlycemiaRecordAdapter());
  await Hive.openBox<GlycemiaRecord>('glycemia_box');

  runApp(const DiabetesTrackApp());
}

class DiabetesTrackApp extends StatelessWidget {
  const DiabetesTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF131824),
        cardColor: const Color(0xFF1E2435),
        primaryColor: const Color(0xFF0FB2A0),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0FB2A0),
          surface: Color(0xFF1E2435),
        ),
      ),
      home: const MainScreen(),
    );
  }
}