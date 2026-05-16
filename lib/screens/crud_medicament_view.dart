import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/glycemia_record.dart';
import '../state/app_state.dart';
import 'add_record_screen.dart';

class CrudMedicamentView extends StatelessWidget {
  final List<GlycemiaRecord> records;
  final String filter;
  const CrudMedicamentView({super.key, required this.records, required this.filter});

  @override
  Widget build(BuildContext context) {
    double totalDoses = records.fold(0, (sum, item) => sum + item.value);

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
                onPressed: () {
                  final filters = ['Tous', 'Insuline Rapide', 'Insuline Basale', 'Metformine'];
                  showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1E2435), builder: (_) => ListView(shrinkWrap: true, children: filters.map((f) => ListTile(title: Center(child: Text(f)), onTap: () { AppState.currentFilter.value = f; Navigator.pop(context); })).toList()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Total injecté / pris : ${totalDoses.toStringAsFixed(1)} U', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final r = records[records.length - 1 - index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    color: const Color(0xFF1E2435),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Colors.cyan),
                      title: Text(r.condition, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(DateFormat('dd MMM yyyy, HH:mm', 'fr').format(r.dateTime)),
                      trailing: Text('${r.value} U', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddRecordScreen(record: r))),
                    ),
                  );
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
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0FB2A0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecordScreen())),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('AJOUTER MÉDICAMENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }
}