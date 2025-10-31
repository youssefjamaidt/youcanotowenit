import 'package:flutter/material.dart';
import '../models/swimmer_model.dart';
import '../services/sync_service.dart';

class AquaticTestPage extends StatefulWidget {
  final Swimmer swimmer;

  const AquaticTestPage({required this.swimmer});

  @override
  _AquaticTestPageState createState() => _AquaticTestPageState();
}

class _AquaticTestPageState extends State<AquaticTestPage> {
  final SyncService _syncService = SyncService();
  final _formKey = GlobalKey<FormState>();

  DateTime _testDate = DateTime.now();
  String _testType = 'training';
  String _stroke = 'Crawl';
  int _distance = 50;
  String _time = '';
  int _strokeRate = 0;
  String _observations = '';
  int _reactionTime = 0;
  int _turnEfficiency = 5;
  int _underwaterDistance = 5;

  final List<String> _strokeTypes = ['Crawl', 'Brasse', 'Dos', 'Papillon'];
  final List<int> _distances = [25, 50, 100, 200, 400];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Aquatique - ${widget.swimmer.name}'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveTest),
          IconButton(icon: Icon(Icons.sync), onPressed: _syncTest),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date et type de test
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Date: ${_testDate.toString().split(' ')[0]}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _selectDate,
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _testType,
                      items: [
                        DropdownMenuItem(value: 'training', child: Text('Entraînement')),
                        DropdownMenuItem(value: 'competition', child: Text('Compétition')),
                      ],
                      onChanged: (value) => setState(() => _testType = value!),
                    ),
                  ),
                ],
              ),

              Divider(),

              // Performance
              Text('Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      items: _distances.map((distance) {
                        return DropdownMenuItem(value: distance, child: Text('${distance}m'));
                      }).toList(),
                      onChanged: (value) => setState(() => _distance = value!),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Temps (mm:ss:ms)'),
                onSaved: (value) => _time = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fréquence de nage'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _strokeRate = int.parse(value ?? '0'),
              ),

              Divider(),

              // Analyse technique
              Text('Analyse Technique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildSlider('Temps réaction départ (ms)', _reactionTime, (value) => _reactionTime = value.round()),
              _buildSlider('Efficacité virage (1-10)', _turnEfficiency, (value) => _turnEfficiency = value.round()),
              _buildSlider('Distance sous-marine (m)', _underwaterDistance, (value) => _underwaterDistance = value.round()),

              TextFormField(
                decoration: InputDecoration(labelText: 'Observations'),
                maxLines: 3,
                onSaved: (value) => _observations = value ?? '',
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTest,
                child: Text('Sauvegarder le test'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.round()}'),
        Slider(
          value: value,
          min: 0,
          max: label.contains('Efficacité') ? 10 : (label.contains('Distance') ? 15 : 1000),
          divisions: label.contains('Efficacité') ? 10 : (label.contains('Distance') ? 15 : 20),
          onChanged: onChanged,
        ),
      ],
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

  void _saveTest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final test = AquaticTest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        swimmerId: widget.swimmer.id,
        testDate: _testDate,
        testType: _testType,
        stroke: _stroke,
        distance: _distance,
        time: _time,
        strokeRate: _strokeRate,
        observations: _observations,
        reactionTime: _reactionTime,
       
