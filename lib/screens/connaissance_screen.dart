import 'package:flutter/material.dart';

class ConnaissanceScreen extends StatelessWidget {
  const ConnaissanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fiches = [
      {
        'title': 'Découvrez les valeurs normales de glycémie',
        'color': const Color(0xFFD4AF37),
        'icon': Icons.bloodtype,
        'content': 'Chez une personne en bonne santé, la glycémie à jeun se situe généralement entre 70 et 99 mg/dL (3,9 à 5,5 mmol/L). Moins de 2 heures après un repas, elle doit rester inférieure à 140 mg/dL.'
      },
      {
        'title': 'En savoir plus sur le diabète',
        'color': const Color(0xFF00A896),
        'icon': Icons.health_and_safety,
        'content': 'Le diabète est une maladie chronique qui survient lorsque le pancréas ne produit pas assez d\'insuline, ou lorsque le corps n\'est pas capable d\'utiliser efficacement l\'insuline qu\'il produit.'
      },
      {
        'title': 'Principaux signes du diabète',
        'color': const Color(0xFFC7525E),
        'icon': Icons.warning_amber,
        'content': 'Les symptômes fréquents incluent une soif excessive (polyidipsie), des mictions fréquentes surtout la nuit, une fatigue intense, une perte de poids inexpliquée et une vision floue.'
      },
      {
        'title': 'Types courants de diabète',
        'color': const Color(0xFF439A86),
        'icon': Icons.biotech,
        'content': '• Diabète de Type 1 : Absence totale de production d\'insuline (auto-immune).\n• Diabète de Type 2 : Utilisation inefficace de l\'insuline liée au mode de vie.\n• Diabète gestationnel : Découvert pendant la grossesse.'
      },
      {
        'title': 'Conseils diététiques pour le diabète',
        'color': const Color(0xFF3B71F3),
        'icon': Icons.restaurant,
        'content': 'Il est recommandé de consommer des glucides complexes à index glycémique bas (lentilles, avoine), d\'incorporer de bonnes graisses (avocat, huile d\'olive) et de limiter au maximum les boissons sucrées.'
      },
      {
        'title': 'Tester la glycémie chez soi',
        'color': const Color(0xFFD4AF37),
        'icon': Icons.home,
        'content': 'Lavez-vous les mains à l\'eau chaude, insérez une bandelette dans le lecteur, piquez le côté du bout du doigt pour obtenir une goutte de sang, puis appliquez-la sur l\'extrémité de la bandelette.'
      },
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fiches.length,
        itemBuilder: (context, index) {
          final item = fiches[index];
          return Card(
            color: item['color'] as Color,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              leading: Icon(item['icon'] as IconData, size: 36, color: Colors.black.withOpacity(0.7)),
              title: Text(
                item['title'] as String,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align( // <-- CORRIGÉ : "Align" au lieu de "Alignment"
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['content'] as String,
                      style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}