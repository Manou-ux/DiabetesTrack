import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'suivi_screen.dart';
import 'connaissance_screen.dart';
import 'parametres_screen.dart';
import 'historique_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SuiviScreen(),
    const ConnaissanceScreen(),
    const ParametresScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF131824),
        elevation: 0,
        title: ValueListenableBuilder<TrackingType>(
          valueListenable: AppState.currentType,
          builder: (context, type, _) {
            return DropdownButton<TrackingType>(
              value: type,
              dropdownColor: const Color(0xFF1E2435),
              underline: const SizedBox(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: const [
                DropdownMenuItem(value: TrackingType.glycemie, child: Text('GLYCÉMIE')),
                DropdownMenuItem(value: TrackingType.medicament, child: Text('MÉDICAMENTS')),
                DropdownMenuItem(value: TrackingType.aliment, child: Text('ALIMENTATION')),
              ],
              onChanged: (TrackingType? newType) {
                if (newType != null) {
                  AppState.currentType.value = newType;
                  AppState.currentFilter.value = 'Tous'; // Reset le filtre au changement
                }
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoriqueScreen()));
            },
            child: const Text('Historique', style: TextStyle(color: Colors.grey, fontSize: 16)),
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1F31),
        selectedItemColor: const Color(0xFF0FB2A0),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Connaissances'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}