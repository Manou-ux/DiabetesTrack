import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/glycemia_record.dart';

class HistoriqueScreen extends StatelessWidget {
  const HistoriqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<GlycemiaRecord>('glycemia_box');

    return Scaffold(
      appBar: AppBar(title: const Text('Historique Global'), backgroundColor: const Color(0xFF131824)),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<GlycemiaRecord> b, _) {
          final records = b.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));

          if (records.isEmpty) {
            return const Center(child: Text('Aucun historique disponible.'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                leading: Icon(Icons.circle, color: record.category == 'Normal' ? Colors.green : Colors.orange),
                title: Text('${record.value} ${record.unit} — ${record.condition}'),
                subtitle: Text(DateFormat('dd MMMM yyyy, HH:mm', 'fr').format(record.dateTime)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => record.delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}