import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/glycemia_record.dart';
import '../state/app_state.dart';
import 'crud_glycemie_view.dart';
import 'crud_medicament_view.dart';
import 'crud_aliment_view.dart';

class SuiviScreen extends StatelessWidget {
  const SuiviScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<GlycemiaRecord>('glycemia_box');

    return ValueListenableBuilder2<TrackingType, String>(
      first: AppState.currentType,
      second: AppState.currentFilter,
      builder: (context, type, filter, _) {
        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<GlycemiaRecord> b, _) {
            final allRecords = b.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

            // Routage vers l'interface CRUD dédiée
            switch (type) {
              case TrackingType.glycemie:
                return CrudGlycemieView(records: allRecords.where((r) => r.type == 'glycemie' && (filter == 'Tous' || r.condition == filter)).toList(), filter: filter);
              case TrackingType.medicament:
                return CrudMedicamentView(records: allRecords.where((r) => r.type == 'medicament' && (filter == 'Tous' || r.condition == filter)).toList(), filter: filter);
              case TrackingType.aliment:
                return CrudAlimentView(records: allRecords.where((r) => r.type == 'aliment' && (filter == 'Tous' || r.condition == filter)).toList(), filter: filter);
            }
          },
        );
      },
    );
  }
}

// Classe utilitaire
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueNotifier<A> first;
  final ValueNotifier<B> second;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;
  const ValueListenableBuilder2({super.key, required this.first, required this.second, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) => ValueListenableBuilder<B>(valueListenable: second, builder: (context, b, _) => builder(context, a, b, null)),
    );
  }
}