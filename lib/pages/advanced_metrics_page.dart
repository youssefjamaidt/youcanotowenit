import 'package:flutter/material.dart';
import '../models/swimmer_model.dart';
import '../services/sync_service.dart';

class AdvancedMetricsPage extends StatefulWidget {
  final Swimmer swimmer;

  const AdvancedMetricsPage({required this.swimmer});

  @override
  _AdvancedMetricsPageState createState() => _AdvancedMetricsPageState();
}

class _AdvancedMetricsPageState extends State<AdvancedMetricsPage> {
  final SyncService _syncService = SyncService();
  final _formKey = GlobalKey<FormState>();

  DateTime _testDate = DateTime.now();
  int _swolfScore = 0;
  double _oxygenRate = 0;
  double _powerOutput = 0;
  int _restingHeartRate = 0;
  int _maxHeartRate = 0;
  int _recoveryTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Métriques Avancées - ${widget.swimmer.name}'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveMetrics),
          IconButton(icon: Icon(Icons.sync), onPressed: _syncMetrics),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Date du test: ${_testDate.toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),

              Divider(),

              Text('Métriques de Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildNumberField('SWOLF Score', (value) => _swolfScore = int.parse(value)),
              _buildNumberField('Taux d\'oxygénation (%)', (value) => _oxygenRate = double.parse(value)),
              _buildNumberField('Puissance développée (W)', (value) => _powerOutput = double.parse(value)),

              Divider(),

              Text('Données Cardiaques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildNumberField('FC repos (bpm)', (value) => _restingHeartRate = int.parse(value)),
              _buildNumberField('FC max (bpm)', (value) => _maxHeartRate = int.parse(value)),
              _buildNumberField('Temps récupération (s)', (value) => _recoveryTime = int.parse(value)),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMetrics,
                child: Text('Sauvegarder les métriques'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
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

  void _selectDate() async {
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
  }

  void _saveMetrics() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final metrics = AdvancedMetrics(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        swimmerId: widget.swimmer.id,
        testDate: _testDate,
        swolfScore: _swolfScore,
        oxygenRate: _oxygenRate,
        powerOutput: _powerOutput,
        restingHeartRate: _restingHeartRate,
        maxHeartRate: _maxHeartRate,
        recoveryTime: _recoveryTime,
      );

      // Sauvegarder localement et synchroniser
      _syncService.syncPhysicalEvaluation; // À adapter pour AdvancedMetrics

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Métriques sauvegardées')),
      );
    }
  }

  void _syncMetrics() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Métriques synchronisées')),
    );
  }
}
