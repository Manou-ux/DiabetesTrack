import 'package:flutter/material.dart';

class ConnaissanceScreen extends StatefulWidget {
  const ConnaissanceScreen({super.key});

  @override
  State<ConnaissanceScreen> createState() => _ConnaissanceScreenState();
}

class _ConnaissanceScreenState extends State<ConnaissanceScreen> {
  // Liste complète des filtres horizontaux
  final List<String> _filters = [
    'Tout',
    'Bases',
    'Diabète',
    'Alimentation',
    'Activité physique',
    'Glycémie',
  ];
  String _selectedFilter = 'Tout';

  // Fonction utilitaire pour insérer une icône alignée au milieu du texte
  WidgetSpan _inlineIcon(IconData icon, Color color) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Liste des fiches avec toutes tes données et émojis convertis en icônes
    final fiches = [
      // SECTION BASES
      {
        'category': 'Bases',
        'title': 'Qu\'est-ce que la glycémie ?',
        'subtitle': 'Comprendre la glycémie et son rôle dans l\'organisme',
        'color': const Color(0xFF0FB2A0),
        'icon': Icons.water_drop_outlined,
        'content': [
          {'text': 'La glycémie désigne le taux de glucose (sucre) dans le sang. Elle est exprimée en mg/dL (milligrammes par décilitre) ou en mmol/L (millimoles par litre).\n\nLe glucose est la principale source d\'énergie de notre organisme. Il provient des aliments que nous consommons, notamment les glucides.\n\n'},
          {'icon': Icons.bar_chart, 'text': 'Valeurs normales :\n', 'isBold': true},
          {'text': '• À jeun : 70 – 100 mg/dL (3.9 – 5.6 mmol/L)\n• 2h après un repas : < 140 mg/dL (< 7.8 mmol/L)\n\n'},
          {'icon': Icons.warning_amber_rounded, 'text': 'Pourquoi la surveiller ?\n', 'isBold': true},
          {'text': 'Un taux de glycémie trop élevé (hyperglycémie) ou trop bas (hypoglycémie) peut avoir des effets graves sur la santé. La surveillance régulière permet d\'éviter les complications.'}
        ]
      },
      {
        'category': 'Bases',
        'title': 'Le rôle de l\'insuline',
        'subtitle': 'Comment l\'insuline régule votre glycémie',
        'color': const Color(0xFF0FB2A0),
        'icon': Icons.flash_on_outlined,
        'content': [
          {'text': 'L\'insuline est une hormone produite par le pancréas. Elle joue un rôle clé dans la régulation de la glycémie.\n\n'},
          {'icon': Icons.settings_suggest_outlined, 'text': 'Son fonctionnement :\n', 'isBold': true},
          {'text': 'Lorsque vous mangez, votre glycémie augmente. Le pancréas libère alors de l\'insuline qui permet aux cellules d\'absorber le glucose pour produire de l\'énergie.\n\n'},
          {'icon': Icons.label_important_outline, 'text': 'Dans le diabète :\n', 'isBold': true},
          {'text': '• Type 1 : le pancréas ne produit plus d\'insuline\n• Type 2 : les cellules résistent à l\'insuline ou le pancréas en produit insuffisamment\n\n'},
          {'icon': Icons.warning_amber_rounded, 'text': 'Sans insuline suffisante, le glucose s\'accumule dans le sang, entraînant une hyperglycémie chronique qui endommage les organes.', 'isBold': true}
        ]
      },
      
      // SECTION DIABÈTE
      {
        'category': 'Diabète',
        'title': 'Types de diabète',
        'subtitle': 'Diabète de type 1, type 2 et gestationnel',
        'color': const Color(0xFF3B71F3),
        'icon': Icons.info_outline_rounded,
        'content': [
          {'text': 'Il existe plusieurs types de diabète, chacun avec ses caractéristiques.\n\n'},
          {'icon': Icons.fiber_manual_record, 'text': 'Diabète de type 1 (DT1)\n', 'isBold': true},
          {'text': 'Maladie auto-immune où le système immunitaire détruit les cellules productrices d\'insuline. Survient généralement chez les jeunes. Traitement : injections d\'insuline quotidiennes.\n\n'},
          {'icon': Icons.fiber_manual_record, 'text': 'Diabète de type 2 (DT2)\n', 'isBold': true},
          {'text': 'Le plus fréquent (90% des cas). L\'organisme ne produit pas assez d\'insuline ou y résiste. Lié au mode de vie. Traitement : alimentation, activité physique, médicaments oraux, parfois insuline.\n\n'},
          {'icon': Icons.fiber_manual_record, 'text': 'Diabète gestationnel\n', 'isBold': true},
          {'text': 'Survient pendant la grossesse. Généralement temporaire mais augmente le risque de DT2 plus tard.\n\n'},
          {'icon': Icons.fiber_manual_record, 'text': 'Prédiabète\n', 'isBold': true},
          {'text': 'Taux de glycémie élevé mais pas encore diabétique. Étape réversible avec des changements de mode de vie.'}
        ]
      },
      {
        'category': 'Diabète',
        'title': 'Complications du diabète',
        'subtitle': 'Les risques d\'un diabète mal contrôlé',
        'color': const Color(0xFFC7525E),
        'icon': Icons.warning_amber_rounded,
        'content': [
          {'text': 'Un diabète mal contrôlé sur le long terme peut provoquer de graves complications.\n\n'},
          {'icon': Icons.favorite_border, 'text': 'Complications vasculaires :\n', 'isBold': true},
          {'text': '• Maladies cardiovasculaires (infarctus, AVC)\n• Rétinopathie (atteinte de la rétine pouvant mener à la cécité)\n• Néphropathie (atteinte des reins)\n• Neuropathie (atteinte des nerfs)\n\n'},
          {'icon': Icons.report_problem_outlined, 'text': 'Complications aiguës :\n', 'isBold': true},
          {'text': '• Hypoglycémie sévère (taux < 70 mg/dL)\n• Hyperglycémie sévère / acidocétose diabétique\n\n'},
          {'icon': Icons.check_circle_outline, 'text': 'Prévention :\n', 'isBold': true},
          {'text': 'Un bon contrôle glycémique, une alimentation équilibrée, l\'exercice régulier et le suivi médical réduisent considérablement ces risques. C\'est pourquoi le suivi quotidien est si important !'}
        ]
      },
      
      // SECTION ALIMENTATION
      {
        'category': 'Alimentation',
        'title': 'Alimentation et glycémie',
        'subtitle': 'Comment l\'alimentation influence votre glycémie',
        'color': const Color(0xFFD4AF37),
        'icon': Icons.restaurant,
        'content': [
          {'text': 'L\'alimentation a un impact direct sur la glycémie. Comprendre l\'index glycémique aide à mieux gérer son diabète.\n\n'},
          {'icon': Icons.bar_chart, 'text': 'L\'index glycémique (IG)\n', 'isBold': true},
          {'text': 'Mesure la vitesse à laquelle un aliment élève la glycémie :\n• IG bas (< 55) : légumineuses, légumes verts, fruits (pomme, poire)\n• IG moyen (55-70) : riz complet, pain complet, banane\n• IG élevé (> 70) : pain blanc, sodas, confiseries\n\n'},
          {'icon': Icons.lightbulb_outline, 'text': 'Conseils pratiques :\n', 'isBold': true},
          {'text': '• Privilégier les fibres (légumes, légumineuses) : ralentissent l\'absorption du sucre\n• Fractionner les repas : 3 repas + collations légères\n• Limiter les sucres raffinés et boissons sucrées\n• Combiner glucides avec protéines et graisses saines\n\n'},
          {'icon': Icons.cancel_outlined, 'text': 'À éviter :\n', 'isBold': true},
          {'text': 'Sauter des repas, qui peut provoquer une hypoglycémie'}
        ]
      },
      
      // SECTION ACTIVITÉ PHYSIQUE
      {
        'category': 'Activité physique',
        'title': 'Sport et diabète',
        'subtitle': 'Les bienfaits de l\'exercice sur la glycémie',
        'color': const Color(0xFF439A86),
        'icon': Icons.fitness_center,
        'content': [
          {'text': 'L\'activité physique régulière est l\'un des meilleurs outils pour gérer le diabète.\n\n'},
          {'icon': Icons.check_circle_outline, 'text': 'Les bénéfices :\n', 'isBold': true},
          {'text': '• Améliore la sensibilité à l\'insuline\n• Réduit la glycémie pendant et après l\'effort\n• Aide à maintenir un poids sain\n• Réduit le risque cardiovasculaire\n\n'},
          {'icon': Icons.assignment_outlined, 'text': 'Recommandations :\n', 'isBold': true},
          {'text': '• 150 minutes d\'activité modérée par semaine (marche rapide, natation, vélo)\n• Ou 75 minutes d\'activité intense\n\n'},
          {'icon': Icons.warning_amber_rounded, 'text': 'Précautions :\n', 'isBold': true},
          {'text': '• Mesurer la glycémie avant, pendant et après l\'effort\n• Éviter l\'exercice si glycémie < 100 mg/dL sans collation préalable\n• Avoir du sucre rapide à portée de main (risque d\'hypoglycémie)\n• Rester bien hydraté\n• Consultez votre médecin avant de démarrer un nouveau programme sportif'}
        ]
      },
      
      // SECTION GLYCÉMIE
      {
        'category': 'Glycémie',
        'title': 'Gérer l\'hypoglycémie',
        'subtitle': 'Reconnaître et traiter une glycémie trop basse',
        'color': const Color(0xFFEF4444),
        'icon': Icons.arrow_downward,
        'content': [
          {'text': 'L\'hypoglycémie survient quand la glycémie descend en dessous de 70 mg/dL (3.9 mmol/L).\n\n'},
          {'icon': Icons.notifications_active_outlined, 'text': 'Symptômes :\n', 'isBold': true},
          {'text': '• Tremblements, sueurs\n• Palpitations, nervosité\n• Faim soudaine\n• Maux de tête, difficultés de concentration\n• Dans les cas sévères : perte de conscience\n\n'},
          {'icon': Icons.search_rounded, 'text': 'Causes fréquentes :\n', 'isBold': true},
          {'text': '• Repas sauté ou insuffisant\n• Activité physique intense\n• Excès d\'insuline ou de médicaments\n• Consommation d\'alcool\n\n'},
          {'icon': Icons.flash_on, 'text': 'Que faire immédiatement ?\n', 'isBold': true},
          {'text': 'La règle des 15 : consommer 15g de glucides rapides (3 morceaux de sucre, 1/2 soda, jus de fruit) puis attendre 15 minutes et vérifier à nouveau la glycémie.'}
        ]
      },
      {
        'category': 'Glycémie',
        'title': 'Gérer l\'hyperglycémie',
        'subtitle': 'Reconnaître et traiter une glycémie trop élevée',
        'color': const Color(0xFFF59E0B),
        'icon': Icons.arrow_upward,
        'content': [
          {'text': 'L\'hyperglycémie survient quand la glycémie dépasse 126 mg/dL (7.0 mmol/L) à jeun ou 180 mg/dL (10.0 mmol/L) après un repas.\n\n'},
          {'icon': Icons.notifications_active_outlined, 'text': 'Symptômes :\n', 'isBold': true},
          {'text': '• Soif excessive (polydipsie)\n• Envies fréquentes d\'uriner (polyurie)\n• Fatigue intense\n• Vision floue\n• Bouche sèche\n• Maux de tête\n\n'},
          {'icon': Icons.search_rounded, 'text': 'Causes fréquentes :\n', 'isBold': true},
          {'text': '• Repas trop riche en glucides\n• Oubli ou dose insuffisante d\'insuline/médicaments\n• Stress, maladie, infection\n• Manque d\'activité physique\n\n'},
          {'icon': Icons.flash_on, 'text': 'Que faire ?\n', 'isBold': true},
          {'text': '• Buvez beaucoup d\'eau (pour éliminer l\'excès de glucose)\n• Faites de l\'exercice léger (si glycémie < 250 mg/dL)\n• Vérifiez votre glycémie régulièrement\n• Suivez votre traitement prescrit\n\n'},
          {'icon': Icons.medical_services_outlined, 'text': 'Urgence médicale si :\n', 'isBold': true},
          {'text': '• Vomissements persistants\n• Douleurs abdominales\n• Haleine fruitée (signe d\'acidocétose)\n• Confusion ou perte de connaissance'}
        ]
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF131824),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête Titre & Sous-titre
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Guide sur le diabète et la glycémie',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Barre des puces horizontales
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : 'Tout';
                      });
                    },
                    selectedColor: const Color(0xFF0FB2A0),
                    backgroundColor: const Color(0xFF1E2435),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    elevation: 0,
                    pressElevation: 0,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Liste de fiches interactives
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: fiches.length,
                itemBuilder: (context, index) {
                  final item = fiches[index];
                  final category = item['category'] as String;

                  // Gestion dynamique du filtrage
                  if (_selectedFilter != 'Tout' && category != _selectedFilter) {
                    return const SizedBox.shrink();
                  }

                  final cardColor = item['color'] as Color;
                  final contentList = item['content'] as List<Map<String, dynamic>>;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2435),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'] as IconData, color: cardColor, size: 22),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: TextStyle(color: cardColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['title'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['subtitle'] as String,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 20),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                children: contentList.map((segment) {
                                  if (segment.containsKey('icon')) {
                                    return TextSpan(
                                      children: [
                                        _inlineIcon(segment['icon'] as IconData, cardColor),
                                        TextSpan(
                                          text: segment['text'] as String,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: segment['isBold'] == true ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return TextSpan(
                                      text: segment['text'] as String,
                                      style: const TextStyle(color: Color(0xFFB0B8C6)),
                                    );
                                  }
                                }).toList(),
                              ),
                              style: const TextStyle(fontSize: 13.5, height: 1.5),
                            ),
                          )
                        ],
                      ),
                    ),
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