import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/glycemia_record.dart';
import '../state/app_state.dart';
import 'add_record_screen.dart';

class CrudGlycemieView extends StatelessWidget {
  final List<GlycemiaRecord> records;
  final String filter;
  const CrudGlycemieView({super.key, required this.records, required this.filter});

  // Fonction utilitaire pour adapter la valeur stockée à l'unité d'affichage globale
  double _getConvertedValue(GlycemiaRecord r, String currentGlobalUnit) {
    if (r.unit.toLowerCase() == currentGlobalUnit.toLowerCase()) {
      return r.value;
    }
    // Conversion dynamique à la volée
    if (r.unit == 'mg/dL' && currentGlobalUnit == 'mmol/l') {
      return r.value / 18.0182;
    } else if (r.unit == 'mmol/l' && currentGlobalUnit == 'mg/dL') {
      return r.value * 18.0182;
    }
    return r.value;
  }

  // Renvoie la couleur exacte associée à la catégorie d'un enregistrement
  Color _getStatusColor(String category) {
    switch (category) {
      case 'Basse':
        return const Color(0xFF3B82F6); // Bleu
      case 'Prédiabète':
        return const Color(0xFFFBBF24); // Jaune / Orange
      case 'Diabète':
        return const Color(0xFFEF4444); // Rouge
      default:
        return const Color(0xFF10B981); // Normal (Vert)
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppState.globalUnit,
      builder: (context, unit, _) {
        double recent = records.isNotEmpty ? _getConvertedValue(records.last, unit) : 0.0;
        double moyenne = records.isNotEmpty
            ? records.map((e) => _getConvertedValue(e, unit)).reduce((a, b) => a + b) / records.length
            : 0.0;

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ActionChip(
                    avatar: const Icon(Icons.filter_list, size: 16, color: Colors.white),
                    label: Text(filter, style: const TextStyle(color: Colors.white)),
                    backgroundColor: const Color(0xFF2C354A),
                    onPressed: () => _openFilterPicker(context),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stat('Récent', recent, unit),
                      _stat('Moyenne', moyenne, unit),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Section Graphique stylisée avec sa boîte sombre intégrée
                _buildCardChartStructure(unit),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final r = records[records.length - 1 - index];
                      return _buildCard(context, r, unit);
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16, left: 16, right: 16,
              child: SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0FB2A0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecordScreen())),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('AJOUTER', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _stat(String title, double val, String unit) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(val > 0 ? val.toStringAsFixed(1) : '--', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    ],
  );

  // Structure globale contenant le titre, les légendes et le graphique scrollable
  Widget _buildCardChartStructure(String unit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2435).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Évolution de la glycémie',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            records.isEmpty 
              ? 'Aucune donnée disponible'
              : (records.length == 1 
                  ? '1 seul enregistrement' 
                  : 'Période : ${DateFormat('dd MMM', 'fr').format(records.first.dateTime)} - ${DateFormat('dd MMM', 'fr').format(records.last.dateTime)}'),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          // Zone du graphique gérant le défilement horizontal et l'affichage
          _buildAdvancedChart(unit),
          const SizedBox(height: 16),
          // Légendes horizontales en bas du graphique
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Basse', const Color(0xFF3B82F6)),
              _buildLegendItem('Normale', const Color(0xFF10B981)),
              _buildLegendItem('Prédiabète', const Color(0xFFFBBF24)),
              _buildLegendItem('Diabète', const Color(0xFFEF4444)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

Widget _buildAdvancedChart(String unit) {
    if (records.isEmpty) {
      return const SizedBox(height: 160, child: Center(child: Text('Aucune donnée pour le graphique')));
    }

    // Calcul de la largeur dynamique pour permettre le défilement horizontal (scroll)
    double chartWidth = records.length * 65.0;
    if (chartWidth < 320) chartWidth = 320;

    return SizedBox(
      height: 160,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // Démarre le scroll vers la droite (les données les plus récentes)
        child: SizedBox(
          width: chartWidth,
          child: LineChart(
            LineChartData(
              // CONFIGURATION DE LA GRILLE : Uniquement les graduations verticales
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: false, // On désactive les lignes horizontales
                drawVerticalLine: true,   // On active les lignes verticales comme avant
                getDrawingVerticalLine: (value) => const FlLine(
                  color: Color(0xFF2C354A), // Couleur d'origine de tes lignes verticales
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int idx = value.toInt();
                      if (idx >= 0 && idx < records.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd').format(records[idx].dateTime), // Format 'dd' d'origine
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40, // Taille d'origine réservée pour l'axe Y
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1), // Format décimal d'origine (.1)
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: records.asMap().entries.map((e) => FlSpot(e.key.toDouble(), _getConvertedValue(e.value, unit))).toList(),
                  isCurved: true,
                  color: const Color(0xFF0FB2A0), 
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      final record = records[index];
                      final dotColor = _getStatusColor(record.category);
                      return FlDotCirclePainter(
                        radius: 5,
                        color: dotColor,
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF1E2435), 
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0FB2A0).withOpacity(0.25),
                        const Color(0xFF0FB2A0).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, GlycemiaRecord r, String unit) {
    Color statusColor = _getStatusColor(r.category);
    double displayValue = _getConvertedValue(r, unit);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF1E2435), borderRadius: BorderRadius.circular(16)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(color: statusColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${r.category} • ${r.condition}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(DateFormat('MMMM dd, HH:mm', 'fr').format(r.dateTime), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
            ),
            Text(displayValue.toStringAsFixed(1), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddRecordScreen(record: r))),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterPicker(BuildContext context) {
    final filters = ['Tous', 'Défaut du système', 'Jeûne', 'Avant un repas', 'Après un repas (1 h)'];
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1E2435), builder: (_) => ListView(shrinkWrap: true, children: filters.map((f) => ListTile(title: Center(child: Text(f)), onTap: () { AppState.currentFilter.value = f; Navigator.pop(context); })).toList()));
  }
}