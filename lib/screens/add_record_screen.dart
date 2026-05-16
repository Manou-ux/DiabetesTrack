import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/glycemia_record.dart';
import '../state/app_state.dart';

class AddRecordScreen extends StatefulWidget {
  final GlycemiaRecord? record;
  const AddRecordScreen({super.key, this.record});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  late TextEditingController _valueController;
  late TextEditingController _customConditionController;
  late TextEditingController _notesController; // <-- NOUVEAU : Pour gérer le texte de la remarque
  late String _selectedUnit;
  late String _selectedCondition;
  DateTime _selectedDateTime = DateTime.now();
  late TrackingType _type;
  bool _isCustomCondition = false;

  @override
  void initState() {
    super.initState();
    _type = AppState.currentType.value;
    final isEdit = widget.record != null;

    _selectedUnit = isEdit ? widget.record!.unit : (_type == TrackingType.glycemie ? AppState.globalUnit.value : (_type == TrackingType.medicament ? 'U' : 'g'));
    _valueController = TextEditingController(text: isEdit ? widget.record!.value.toString() : (_type == TrackingType.glycemie ? (_selectedUnit == 'mg/dL' ? '65.0' : '3.6') : '5.0'));
    _selectedCondition = isEdit ? widget.record!.condition : (_type == TrackingType.glycemie ? 'Jeûne' : (_type == TrackingType.medicament ? 'Insuline Rapide' : 'Glucides - Petit Déj'));
    _customConditionController = TextEditingController(text: isEdit ? widget.record!.condition : '');
    
    // --- NOUVEAU : Initialisation de la remarque si elle existe déjà ---
    _notesController = TextEditingController(text: isEdit ? widget.record!.notes : '');
  }

  @override
  void dispose() {
    _valueController.dispose();
    _customConditionController.dispose();
    _notesController.dispose(); // <-- Libération de la mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double currentVal = double.tryParse(_valueController.text) ?? 0.0;
    String currentCat = _type == TrackingType.glycemie ? GlycemiaRecord.getCategoryFor(value: currentVal, unit: _selectedUnit) : 'Suivi';

    return Scaffold(
      backgroundColor: const Color(0xFF131824),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Text(widget.record == null ? 'Nouvel enregistrement' : 'Modifier'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (widget.record != null)
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: _deleteRecord)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showConditionPicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1E2435), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Condition', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(_isCustomCondition ? "Manuelle : $_selectedCondition" : _selectedCondition, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
              ),
            ),
            if (_isCustomCondition) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _customConditionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Saisir manuellement le type...',
                  filled: true,
                  fillColor: const Color(0xFF1E2435),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (v) => _selectedCondition = v,
              )
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFF1E2435), borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: (v) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_type == TrackingType.glycemie)
                  Column(
                    children: [
                      _buildUnitButton('mg/dL'),
                      const SizedBox(height: 6),
                      _buildUnitButton('mmol/l'),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF1E2435), borderRadius: BorderRadius.circular(8)),
                    child: Text(_selectedUnit, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  )
              ],
            ),
            const SizedBox(height: 24),
            if (_type == TrackingType.glycemie) ...[
              _buildIntervalLegend(currentCat),
              const SizedBox(height: 24),
            ],
            
            // --- BOX DATE & HEURE DESIGN AVEC IMPORT DU BOUTON REMARQUE DE LA PHOTO ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E2435), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date et heure', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                      
                      // Bouton Remarque + dynamique comme demandé
                      TextButton.icon(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        onPressed: _showNotesInputDialog,
                        icon: const Icon(Icons.add, size: 16, color: Color(0xFF0FB2A0)),
                        label: Text(
                          _notesController.text.isNotEmpty ? 'Modifier Remarque' : 'Remarque',
                          style: const TextStyle(color: Color(0xFF0FB2A0), fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today, color: Color(0xFF0FB2A0)),
                    title: Text(
                      DateFormat('yyyy - MMMM dd - HH:mm', 'fr').format(_selectedDateTime),
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    onTap: () async {
                      final d = await showDatePicker(context: context, initialDate: _selectedDateTime, firstDate: DateTime(2020), lastDate: DateTime.now());
                      if (d != null) {
                        final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDateTime));
                        if (t != null) {
                          setState(() { _selectedDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute); });
                        }
                      }
                    },
                  ),
                  
                  // --- AFFICHAGE DE LA REMARQUE SAISIE SI NON VIDE ---
                  if (_notesController.text.isNotEmpty) ...[
                    const Divider(color: Color(0xFF2C354A)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.notes, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _notesController.text,
                              style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0FB2A0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: _saveRecord,
                child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitButton(String unit) {
    bool isSelected = _selectedUnit.toLowerCase() == unit.toLowerCase();
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: isSelected ? const Color(0xFF0FB2A0) : const Color(0xFF1E2435)),
        onPressed: () => setState(() => _selectedUnit = unit),
        child: Text(unit, style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
      ),
    );
  }

  Widget _buildIntervalLegend(String currentCat) {
    final tranches = GlycemiaRecord.getLegendForUnit(_selectedUnit);
    return Column(
      children: tranches.map((t) {
        bool isCurrent = currentCat == t['name'];
        return Row(
          children: [
            Icon(Icons.arrow_right, color: isCurrent ? Colors.white : Colors.transparent),
            Container(width: 16, height: 16, color: t['color'] as Color),
            const SizedBox(width: 12),
            Expanded(child: Text(t['name'] as String, style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal))),
            Text(t['range'] as String),
          ],
        );
      }).toList(),
    );
  }

  void _showConditionPicker() {
    List<String> conditions = [];
    if (_type == TrackingType.glycemie) {
      conditions = ['Défaut du système', 'Jeûne', 'Avant un repas', 'Après un repas (1 h)'];
    } else if (_type == TrackingType.medicament) {
      conditions = ['Insuline Rapide', 'Insuline Basale', 'Metformine', 'Autre (Saisie manuelle)...'];
    } else {
      conditions = ['Glucides - Petit Déj', 'Glucides - Déjeuner', 'Glucides - Dîner', 'Autre (Saisie manuelle)...'];
    }

    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF1E2435),
      builder: (_) => ListView(
        shrinkWrap: true, 
        children: conditions.map((c) => ListTile(
          title: Center(child: Text(c)), 
          onTap: () {
            setState(() {
              if (c.contains('Autre')) {
                _isCustomCondition = true;
                _selectedCondition = _customConditionController.text.isNotEmpty ? _customConditionController.text : 'Personnalisé';
              } else {
                _isCustomCondition = false;
                _selectedCondition = c;
              }
            });
            Navigator.pop(context);
          }
        )).toList()
      ),
    );
  }

  // --- NOUVEAU : BOÎTE DE DIALOGUE POUR AJOUTER LA NOTE ---
  void _showNotesInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2435),
        title: const Text('Ajouter une remarque', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: _notesController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Saisissez vos notes ou remarques ici...',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF131824),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0FB2A0)),
            onPressed: () {
              setState(() {}); // Rafraîchit l'UI pour voir le texte sous la date
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _saveRecord() {
    final val = double.tryParse(_valueController.text) ?? 0.0;
    if (val <= 0 || _selectedCondition.isEmpty) return;

    final cat = _type == TrackingType.glycemie ? GlycemiaRecord.getCategoryFor(value: val, unit: _selectedUnit) : 'Enregistré';
    final box = Hive.box<GlycemiaRecord>('glycemia_box');
    final typeString = _type == TrackingType.glycemie ? 'glycemie' : (_type == TrackingType.medicament ? 'medicament' : 'aliment');

    // Sauvegarde en base en injectant la valeur de _notesController.text
    if (widget.record != null) {
      widget.record!.value = val;
      widget.record!.unit = _selectedUnit;
      widget.record!.condition = _selectedCondition;
      widget.record!.category = cat;
      widget.record!.dateTime = _selectedDateTime;
      widget.record!.type = typeString;
      widget.record!.notes = _notesController.text; // <-- ENREGISTREMENT DE LA MODIFICATION
      widget.record!.save();
    } else {
      box.add(GlycemiaRecord(
        value: val, 
        unit: _selectedUnit, 
        condition: _selectedCondition, 
        category: cat, 
        dateTime: _selectedDateTime, 
        type: typeString,
        notes: _notesController.text, // <-- ENREGISTREMENT DU NOUVEL ELEMENT
      ));
    }
    Navigator.pop(context);
  }

  void _deleteRecord() {
    if (widget.record != null) {
      widget.record!.delete();
      Navigator.pop(context);
    }
  }
}