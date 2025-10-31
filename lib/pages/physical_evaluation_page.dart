import 'package:flutter/material.dart';
import '../models/swimmer_model.dart';
import '../services/sync_service.dart';

class PhysicalEvaluationPage extends StatefulWidget {
  final Swimmer swimmer;

  const PhysicalEvaluationPage({required this.swimmer});

  @override
  _PhysicalEvaluationPageState createState() => _PhysicalEvaluationPageState();
}

class _PhysicalEvaluationPageState extends State<PhysicalEvaluationPage> {
  final SyncService _syncService = SyncService();
  final _formKey = GlobalKey<FormState>();

  DateTime _testDate = DateTime.now();
  double _weight = 0;
  double _height = 0;
  double _bodyFat = 0;
  double _muscleMass = 0;
  int _pullUps = 0;
  int _pushUps = 0;
  int _plankTime = 0;
  double _squatMax = 0;
  String _shoulderFlexibility = 'Moyenne';
  String _hipFlexibility = 'Moyenne';
  String _ankleMobility = 'Moyenne';

  final List<String> _flexibilityOptions = ['Excellente', 'Bonne', 'Moyenne', 'Faible'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Évaluation Physique - ${widget.swimmer.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveEvaluation,
          ),
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: _syncEvaluation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date du test
              ListTile(
                title: Text('Date du test: ${_testDate.toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _testDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _testDate = date;
                    });
                  }
                },
              ),

              Divider(),

              // Données physiques
              Text('Données Physiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildNumberField('Poids (kg)', (value) => _weight = double.parse(value)),
              _buildNumberField('Taille (cm)', (value) => _height = double.parse(value)),
              _buildNumberField('Masse grasse (%)', (value) => _bodyFat = double.parse(value)),
              _buildNumberField('Masse musculaire (%)', (value) => _muscleMass = double.parse(value)),

              Divider(),

              // Tests de force
              Text('Tests de Force', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildNumberField('Tractions max', (value) => _pullUps = int.parse(value)),
              _buildNumberField('Pompes en 1 min', (value) => _pushUps = int.parse(value)),
              _buildNumberField('Gainage (secondes)', (value) => _plankTime = int.parse(value)),
              _buildNumberField('Squat max (kg)', (value) => _squatMax = double.parse(value)),

              Divider(),

              // Souplesse et mobilité
              Text('Souplesse et Mobilité', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildDropdown('Rotation épaules', _shoulderFlexibility, (value) => _shoulderFlexibility = value!),
              _buildDropdown('Flexibilité hanches', _hipFlexibility, (value) => _hipFlexibility = value!),
              _buildDropdown('Mobilité chevilles', _ankleMobility, (value) => _ankleMobility = value!),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvaluation,
                child: Text('Sauvegarder l\'évaluation'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String) onSaved) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onSaved: (value) => onSaved(value ?? '0'),
    );
  }

  Widget _buildDropdown(String label, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: _flexibilityOptions.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _saveEvaluation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final evaluation = PhysicalEvaluation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        swimmerId: widget.swimmer.id,
        testDate: _testDate,
        weight: _weight,
        height: _height,
        bodyFat: _bodyFat,
        muscleMass: _muscleMass,
        pullUps: _pullUps,
        pushUps: _pushUps,
        plankTime: _plankTime,
        squatMax: _squatMax,
        shoulderFlexibility: _shoulderFlexibility,
        hipFlexibility: _hipFlexibility,
        ankleMobility: _ankleMobility,
      );

      // Sauvegarder localement
      _syncService.syncPhysicalEvaluation(evaluation);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Évaluation sauvegardée')),
      );
    }
  }

  void _syncEvaluation() {
    // Synchroniser avec le cloud
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Données synchronisées')),
    );
  }
}
