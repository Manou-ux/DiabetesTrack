import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/glycemia_record.dart';
import '../state/app_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  void _exporterDonnees(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Données exportées avec succès (CSV) !'),
        backgroundColor: Color(0xFF0FB2A0),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _afficherOptionsSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext optionsContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2435),
          title: const Text(
            'Que souhaitez-vous effacer ?',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDeleteOption(
                context: optionsContext,
                title: 'Glycémie uniquement',
                icon: Icons.water_drop_outlined,
                color: const Color(0xFF0FB2A0),
                onTap: () => _confirmerSuppressionSpecifique(context, 'glycemie', 'la glycémie'),
              ),
              _buildDeleteOption(
                context: optionsContext,
                title: 'Médicaments uniquement',
                icon: Icons.medication_outlined,
                color: const Color(0xFF3B71F3),
                onTap: () => _confirmerSuppressionSpecifique(context, 'medicament', 'les médicaments'),
              ),
              _buildDeleteOption(
                context: optionsContext,
                title: 'Alimentation uniquement',
                icon: Icons.restaurant_outlined,
                color: const Color(0xFFD4AF37),
                onTap: () => _confirmerSuppressionSpecifique(context, 'aliment', 'l\'alimentation'),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Color(0xFF2C354A)),
              ),
              _buildDeleteOption(
                context: optionsContext,
                title: 'Tout effacer / Réinitialiser',
                icon: Icons.delete_forever,
                color: const Color(0xFFFF4D4D),
                onTap: () => _confirmerSuppressionTotale(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(optionsContext),
              child: const Text('Fermer', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 12),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _confirmerSuppressionSpecifique(BuildContext context, String typeCle, String labelAffichage) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2435),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF4D4D)),
              const SizedBox(width: 10),
              Text('Supprimer $labelAffichage', style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: Text(
            'Cette action effacera uniquement les données liées à $labelAffichage. Êtes-vous sûr de vouloir continuer ?',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                final keysToDelete = box.keys.where((key) {
                  final record = box.get(key);
                  return record != null && record.type == typeCle;
                }).toList();

                for (var key in keysToDelete) {
                  await box.delete(key);
                }

                if (context.mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Les données concernant $labelAffichage ont été supprimées.'),
                      backgroundColor: const Color(0xFF0FB2A0),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Confirmer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

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
            'Cette action effacera toutes les données enregistrées ? Êtes-vous absolument sûr de vouloir continuer ?',
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
                await box.clear();

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
                SystemNavigator.pop();
              },
              child: const Text('Oui', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- NOUVEAU : Widget pour une boîte de statistique individuelle ---
  Widget _buildStatBox(String label, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2435),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131824),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            const SizedBox(height: 30),
            const Text(
              'Données et rapports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
            ),
            const SizedBox(height: 15),

            // --- NOUVEAU : SECTION STATISTIQUES DYNAMIQUE ---
            const Text(
              'STATISTIQUES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: Hive.box<GlycemiaRecord>('glycemia_box').listenable(),
              builder: (context, Box<GlycemiaRecord> box, _) {
                final glyCount = box.values.where((r) => r.type == 'glycemie').length;
                final medCount = box.values.where((r) => r.type == 'medicament').length;
                final aliCount = box.values.where((r) => r.type == 'aliment').length;

                return Row(
                  children: [
                    _buildStatBox('Mesures\nglycémie', glyCount, Icons.stacked_line_chart, const Color(0xFF0FB2A0)),
                    const SizedBox(width: 10),
                    _buildStatBox('Médicaments', medCount, Icons.medication_outlined, const Color(0xFF3B71F3)),
                    const SizedBox(width: 10),
                    _buildStatBox('Repas', aliCount, Icons.coffee_rounded, const Color(0xFFD4AF37)),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            Column(
              children: [
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
                
                GestureDetector(
                  onTap: () => _afficherOptionsSuppression(context),
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
                              'Options de nettoyage des données',
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
                    children: [
                      const Text('Développeur', style: TextStyle(fontSize: 16, color: Colors.white)),
                      
                      // Remplacement du simple texte par un bouton Dropbox interactif
                      PopupMenuButton<String>(
                        tooltip: 'Afficher les contacts',
                        offset: const Offset(0, 30), // Décale le menu légèrement vers le bas
                        color: const Color(0xFF1E2435), // Aligné avec ton thème sombre
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Rajosvah Manou', 
                              style: TextStyle(fontSize: 16, color: Colors.grey)
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
                          ],
                        ),
                        onSelected: (String url) async {
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            // Gestion d'erreur ou fallback si le lien ne s'ouvre pas
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Impossible d\'ouvrir : $url')),
                              );
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[

                          PopupMenuItem<String>(
                            value: 'https://facebook.com/manou.rajosvah', 
                            child: Row(
                              children: const [
                                Icon(Icons.facebook, color: Color(0xFF1877F2), size: 18),
                                SizedBox(width: 10),
                                Text('Facebook', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'mailto:rajosvahmanou@gmail.com', 
                            child: Row(
                              children: const [
                                Icon(Icons.email_outlined, color: Colors.orangeAccent, size: 18),
                                SizedBox(width: 10),
                                Text('Email', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'https://github.com/Manou-ux', 
                            child: Row(
                              children: const [
                                Icon(Icons.code, color: Colors.white70, size: 18),
                                SizedBox(width: 10),
                                Text('GitHub', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'https://linkedin.com/in/manou-rajosvah-ba5448390', 
                            child: Row(
                              children: const [
                                Icon(Icons.business, color: Color(0xFF0A66C2), size: 18),
                                SizedBox(width: 10),
                                Text('LinkedIn', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => _confirmerQuitterApplication(context),
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