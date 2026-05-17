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
        // CONDITION : Si _currentIndex == 0 (Tracker), on affiche le Dropdown.
        // Sinon, on affiche un simple titre textuel adapté.
        title: _currentIndex == 0
            ? ValueListenableBuilder<TrackingType>(
                valueListenable: AppState.currentType,
                builder: (context, type, _) {
                  return DropdownButton<TrackingType>(
                    value: type,
                    dropdownColor: const Color(0xFF1E2435),
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: const [
                      DropdownMenuItem(
                        value: TrackingType.glycemie,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.water_drop_outlined, color: Color(0xFF0FB2A0), size: 20),
                            SizedBox(width: 10),
                            Text('GLYCÉMIE'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: TrackingType.medicament,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.medication_outlined, color: Color(0xFF3B71F3), size: 20),
                            SizedBox(width: 10),
                            Text('MÉDICAMENTS'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: TrackingType.aliment,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restaurant_outlined, color: Color(0xFFD4AF37), size: 20),
                            SizedBox(width: 10),
                            Text('ALIMENTATION'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (TrackingType? newType) {
                      if (newType != null) {
                        AppState.currentType.value = newType;
                        AppState.currentFilter.value = 'Tous'; // Reset le filtre au changement
                      }
                    },
                  );
                },
              )
            : Text(
                _currentIndex == 1 ? 'CONNAISSANCES' : 'PARAMÈTRES',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
              ),
        // Cache également le bouton Historique si on n'est pas sur le Tracker
        actions: [
          if (_currentIndex == 0)
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
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Suivi'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Connaissances'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}