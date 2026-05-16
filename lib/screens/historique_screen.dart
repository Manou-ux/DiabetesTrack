import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/glycemia_record.dart';
import '../state/app_state.dart'; // Import nécessaire pour TrackingType

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  // Filtre sélectionné : null correspond à "Tous"
  TrackingType? _selectedFilter;

  // Récupère l'icône appropriée selon le type de record
  IconData _getIconData(String type) {
    switch (type) {
      case 'medicament':
        return Icons.medication_outlined;
      case 'aliment':
        return Icons.restaurant_outlined;
      case 'glycemie':
      default:
        return Icons.water_drop_outlined;
    }
  }

  // Récupère la couleur exacte spécifiée selon le type de record
  Color _getIconColor(String type) {
    switch (type) {
      case 'medicament':
        return const Color(0xFF3B71F3);
      case 'aliment':
        return const Color(0xFFD4AF37);
      case 'glycemie':
      default:
        return const Color(0xFF0FB2A0);
    }
  }

  // Traduit le type de chaîne technique de la base Hive vers l'enum de filtrage
  bool _matchesFilter(String recordType) {
    if (_selectedFilter == null) return true;
    if (_selectedFilter == TrackingType.glycemie && recordType == 'glycemie') return true;
    if (_selectedFilter == TrackingType.medicament && recordType == 'medicament') return true;
    if (_selectedFilter == TrackingType.aliment && recordType == 'aliment') return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<GlycemiaRecord>('glycemia_box');

    return Scaffold(
      backgroundColor: const Color(0xFF131824),
      appBar: AppBar(
        title: const Text('Historique Global'),
        backgroundColor: const Color(0xFF131824),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- BARRE DE FILTRES ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip(label: 'Tous', filterValue: null),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Glycémie', 
                  filterValue: TrackingType.glycemie, 
                  icon: Icons.water_drop_outlined, 
                  color: const Color(0xFF0FB2A0)
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Médicaments', 
                  filterValue: TrackingType.medicament, 
                  icon: Icons.medication_outlined, 
                  color: const Color(0xFF3B71F3)
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Alimentation', 
                  filterValue: TrackingType.aliment, 
                  icon: Icons.restaurant_outlined, 
                  color: const Color(0xFFD4AF37)
                ),
              ],
            ),
          ),
          
          // --- LISTE DE L'HISTORIQUE FILTRÉ ---
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<GlycemiaRecord> b, _) {
                // Filtrage et tri de la liste descendante par date
                final records = b.values
                    .where((r) => _matchesFilter(r.type))
                    .toList()
                  ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

                if (records.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun historique correspondant.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: records.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final record = records[index];
                    final itemColor = _getIconColor(record.type);

                    return Card(
                      color: const Color(0xFF1E2435),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: itemColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIconData(record.type),
                            color: itemColor,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          '${record.value} ${record.unit} — ${record.condition}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            DateFormat('dd MMMM yyyy, HH:mm', 'fr').format(record.dateTime),
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _confirmDelete(context, record),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget d'aide pour concevoir les boutons de filtres réactifs
  Widget _buildFilterChip({
    required String label,
    required TrackingType? filterValue,
    IconData? icon,
    Color? color,
  }) {
    final isSelected = _selectedFilter == filterValue;
    final activeColor = color ?? const Color(0xFF0FB2A0);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon, 
              size: 16, 
              color: isSelected ? Colors.white : activeColor
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[300],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      selectedColor: activeColor,
      backgroundColor: const Color(0xFF1E2435),
      showCheckmark: false, // <-- ICI : Correction appliquée (showCheckmark au lieu de checkmarkEnabled)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : const Color(0xFF2C354A),
        ),
      ),
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? filterValue : null;
        });
      },
    );
  }

  // Dialogue de confirmation de suppression sécurisé
  void _confirmDelete(BuildContext context, GlycemiaRecord record) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2435),
        title: const Text('Supprimer l\'enregistrement ?', style: TextStyle(color: Colors.white)),
        content: const Text('Cette action est irréversible.', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              record.delete();
              Navigator.pop(ctx);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}