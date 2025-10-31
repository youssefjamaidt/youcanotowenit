import 'package:flutter/material.dart';
import '../models/swimmer_model.dart';
import '../services/sync_service.dart';

class GoalsPage extends StatefulWidget {
  final Swimmer swimmer;

  const GoalsPage({required this.swimmer});

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final SyncService _syncService = SyncService();
  final _formKey = GlobalKey<FormState>();

  DateTime _startDate = DateTime.now();
  DateTime _targetDate = DateTime.now().add(Duration(days: 90));
  String _stroke = 'Crawl';
  int _distance = 100;
  String _currentTime = '';
  String _targetTime = '';
  String _specificGoals = '';
  String _trainingPlan = '';

  final List<String> _strokeTypes = ['Crawl', 'Brasse', 'Dos', 'Papillon'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objectifs - ${widget.swimmer.name}'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveGoals),
          IconButton(icon: Icon(Icons.sync), onPressed: _syncGoals),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Période
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Début: ${_startDate.toString().split(' ')[0]}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () => _selectDate(true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Objectif: ${_targetDate.toString().split(' ')[0]}'),
                      trailing: Icon(Icons.flag),
                      onTap: () => _selectDate(false),
                    ),
                  ),
                ],
              ),

              Divider(),

              // Objectif de performance
              Text('Objectif de Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _stroke,
                      items: _strokeTypes.map((stroke) {
                        return DropdownMenuItem(value: stroke, child: Text(stroke));
                      }).toList(),
                      onChanged: (value) => setState(() => _stroke = value!),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _distance,
                      items: [50, 100, 200, 400].map((distance) {
                        return DropdownMenuItem(value: distance, child: Text('${distance}m'));
                      }).toList(),
                      onChanged: (value) => setState(() => _distance = value!),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Temps actuel (mm:ss:ms)'),
                onSaved: (value) => _currentTime = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Temps objectif (mm:ss:ms)'),
                onSaved: (value) => _targetTime = value ?? '',
              ),

              Divider(),

              // Planification
              Text('Plan Détaillé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(labelText: 'Objectifs spécifiques'),
                maxLines: 3,
                onSaved: (value) => _specificGoals = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Plan d\'entraînement'),
                maxLines: 4,
                onSaved: (value) => _trainingPlan = value ?? '',
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoals,
                child: Text('Sauvegarder les objectifs'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _targetDate = date;
        }
      });
    }
  }

  void _saveGoals() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final goals = Goals(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        swimmerId: widget.swimmer.id,
        startDate: _startDate,
        targetDate: _targetDate,
        stroke: _stroke,
        distance: _distance,
        currentTime: _currentTime,
        targetTime: _targetTime,
        specificGoals: _specificGoals,
        trainingPlan: _trainingPlan,
      );

      // Sauvegarder localement
      // _syncService.syncGoals(goals);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Objectifs sauvegardés')),
      );
    }
  }

  void _syncGoals() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Objectifs synchronisés')),
    );
  }
}
