import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Requis pour fermer l'application proprement
import 'package:hive_flutter/hive_flutter.dart'; // Import nécessaire pour vider la box Hive
import '../models/glycemia_record.dart';
import '../state/app_state.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  // Fonction pour simuler ou gérer l'exportation de données de suivi
  void _exporterDonnees(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Données exportées avec succès (CSV) !'),
        backgroundColor: Color(0xFF0FB2A0),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // --- NOUVEAU : ALERTE DE CONFIRMATION POUR SUPPRIMER TOUTES LES DONNÉES ---
  void _confirmerSuppressionTotale(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2435),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF4D4D)),
              SizedBox(width: 10),
              Text('Action Irréversible', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: const Text(
            'Cette action effacera tout les données enregistré ? Êtes-vous absolument sûr de vouloir continuer ?',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4D4D)),
              onPressed: () async {
                final box = Hive.box<GlycemiaRecord>('glycemia_box');
                await box.clear(); // Vide intégralement la box locale Hive

                if (context.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Toutes les données ont été réinitialisées.'),
                      backgroundColor: Color(0xFF0FB2A0),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Tout Effacer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // --- NOUVEAU : ALERTE DE CONFIRMATION POUR QUITTER L'APPLICATION ---
  void _confirmerQuitterApplication(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2435),
          title: const Text('Quitter l\'application', style: TextStyle(color: Colors.white, fontSize: 18)),
          content: const Text(
            'Voulez-vous vraiment fermer l\'application ?',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Non', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0FB2A0)),
              onPressed: () {
                Navigator.pop(dialogContext);
                SystemNavigator.pop(); // Fermeture propre de l'appli
              },
              child: const Text('Oui', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131824), // Ajusté pour garder la cohérence globale du fond
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION PREFERENCES ---
            const Text(
              'Préférences de l\'application',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2435),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: AppState.globalUnit,
                builder: (context, currentUnit, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Unité de Glycémie Globale', style: TextStyle(fontSize: 16, color: Colors.white)),
                      DropdownButton<String>(
                        value: currentUnit,
                        dropdownColor: const Color(0xFF2C354A),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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

            // --- SECTION DONNÉES & RAPPORTS ---
            const SizedBox(height: 30),
            const Text(
              'Données et rapports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                // Bouton Exporter existant
                GestureDetector(
                  onTap: () => _exporterDonnees(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2435),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.share, color: Color(0xFF0FB2A0), size: 22),
                            SizedBox(width: 12),
                            Text('Exporter mes données (CSV)', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // --- NOUVEAU : BOUTON EFFACER TOUTES LES DONNÉES (INTEGRÉ DANS LA SECTION DONNÉES) ---
                GestureDetector(
                  onTap: () => _confirmerSuppressionTotale(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2435),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.delete_forever, color: Color(0xFFFF4D4D), size: 22),
                            SizedBox(width: 12),
                            Text(
                              'Réinitialiser / Effacer toutes les données',
                              style: TextStyle(fontSize: 16, color: Color(0xFFFF4D4D), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- SECTION SYSTÈME & INFO ---
            const SizedBox(height: 30),
            const Text(
              'À propos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2435),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Version de l\'application', style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('1.0.0', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Color(0xFF2C354A), thickness: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Développeur', style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('R. Manou', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            // --- BOUTON DE SORTIE ROUTÉ VERS LA DIALOGUE DE CONFIRMATION ---
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => _confirmerQuitterApplication(context), // Appel de la confirmation de fermeture
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D4D).withOpacity(0.1),
                  border: Border.all(color: const Color(0xFFFF4D4D).withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.exit_to_app, color: Color(0xFFFF4D4D), size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Quitter l\'application',
                      style: TextStyle(fontSize: 16, color: Color(0xFFFF4D4D), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}