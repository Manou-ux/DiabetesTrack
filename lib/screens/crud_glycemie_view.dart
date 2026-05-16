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

  @override
  Widget build(BuildContext context) {
    // Écoute en temps réel de l'unité globale modifiée dans les paramètres
    return ValueListenableBuilder<String>(
      valueListenable: AppState.globalUnit,
      builder: (context, unit, _) {
        // Calcul des stats basées sur les valeurs converties dynamiquement
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
                      _stat('Moyenne (3 jours)', moyenne, unit),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                _buildAdvancedChart(unit), // L'unité choisie pilote la graduation du graphique
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

  Widget _buildAdvancedChart(String unit) {
    if (records.isEmpty) {
      return const SizedBox(height: 160, child: Center(child: Text('Aucune donnée pour le graphique')));
    }

    return Container(
      height: 160,
      padding: const EdgeInsets.only(right: 24, left: 8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: false,
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) => const FlLine(color: Color(0xFF2C354A), strokeWidth: 1),
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
                      child: Text(DateFormat('dd').format(records[idx].dateTime), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  // Les graduations s'adaptent dynamiquement à l'échelle (ex: de 3.0 à 7.0 pour mmol/l ou de 60 à 180 pour mg/dL)
                  return Text(value.toStringAsFixed(1), style: const TextStyle(color: Colors.grey, fontSize: 11));
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              // Attribution des valeurs adaptées à l'unité en cours
              spots: records.asMap().entries.map((e) => FlSpot(e.key.toDouble(), _getConvertedValue(e.value, unit))).toList(),
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF10B981).withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, GlycemiaRecord r, String unit) {
    Color statusColor = Colors.green;
    if (r.category == 'Basse') statusColor = Colors.blue;
    if (r.category == 'Prédiabète') statusColor = Colors.orange;
    if (r.category == 'Diabète') statusColor = Colors.red;

    // Conversion de la valeur de la carte individuelle si nécessaire
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