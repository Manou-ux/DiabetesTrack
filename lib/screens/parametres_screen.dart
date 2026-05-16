import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Préférences de l\'application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF1E2435), borderRadius: BorderRadius.circular(12)),
              child: ValueListenableBuilder<String>(
                valueListenable: AppState.globalUnit,
                builder: (context, currentUnit, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Unité de Glycémie Globale', style: TextStyle(fontSize: 16, color: Colors.white)),
                      DropdownButton<String>(
                        value: currentUnit,
                        dropdownColor: const Color(0xFF2C354A), // Fond contrasté
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), // Texte Blanc
                        iconEnabledColor: const Color(0xFF0FB2A0),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'mg/dL', child: Text('mg/dL')),
                          DropdownMenuItem(value: 'mmol/l', child: Text('mmol/l')),
                        ],
                        onChanged: (String? newUnit) {
                          if (newUnit != null) AppState.globalUnit.value = newUnit;
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}