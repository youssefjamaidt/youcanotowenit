import 'package:flutter/material.dart';
import '../models/swimmer_model.dart';
import '../services/sync_service.dart';
import '../services/print_service.dart';
import 'physical_evaluation_page.dart';
import 'aquatic_test_page.dart';
import 'advanced_metrics_page.dart';
import 'goals_page.dart';

class SwimmerListPage extends StatefulWidget {
  @override
  _SwimmerListPageState createState() => _SwimmerListPageState();
}

class _SwimmerListPageState extends State<SwimmerListPage> {
  final SyncService _syncService = SyncService();
  final List<Swimmer> _swimmers = [];

  @override
  void initState() {
    super.initState();
    _loadSwimmers();
  }

  void _loadSwimmers() {
    // Charger depuis la base de données locale
  }

  void _addSwimmer() {
    showDialog(
      context: context,
      builder: (context) => AddSwimmerDialog(
        onSave: (swimmer) {
          setState(() {
            _swimmers.add(swimmer);
          });
          _syncService.syncSwimmer(swimmer);
        },
      ),
    );
  }

  void _showSwimmerOptions(Swimmer swimmer) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SwimmerOptionsSheet(swimmer: swimmer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Nageurs'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: _syncAllData,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _swimmers.length,
        itemBuilder: (context, index) {
          final swimmer = _swimmers[index];
          return Card(
            child: ListTile(
              title: Text(swimmer.name),
              subtitle: Text('${swimmer.category} - ${swimmer.club}'),
              trailing: PopupMenuButton(
                onSelected: (value) => _handleMenuSelection(value, swimmer),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'print', child: Text('Imprimer')),
                  PopupMenuItem(value: 'physical', child: Text('Évaluation Physique')),
                  PopupMenuItem(value: 'aquatic', child: Text('Test Aquatique')),
                  PopupMenuItem(value: 'metrics', child: Text('Métriques Avancées')),
                  PopupMenuItem(value: 'goals', child: Text('Objectifs')),
                ],
              ),
              onTap: () => _showSwimmerOptions(swimmer),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSwimmer,
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleMenuSelection(String value, Swimmer swimmer) {
    switch (value) {
      case 'print':
        PrintService.printSwimmerProfile(swimmer);
        break;
      case 'physical':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhysicalEvaluationPage(swimmer: swimmer),
          ),
        );
        break;
      case 'aquatic':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AquaticTestPage(swimmer: swimmer),
          ),
        );
        break;
      case 'metrics':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvancedMetricsPage(swimmer: swimmer),
          ),
        );
        break;
      case 'goals':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalsPage(swimmer: swimmer),
          ),
        );
        break;
    }
  }

  void _syncAllData() {
    // Synchroniser toutes les données
    for (final swimmer in _swimmers) {
      _syncService.syncSwimmer(swimmer);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Synchronisation terminée')),
    );
  }
}

class AddSwimmerDialog extends StatefulWidget {
  final Function(Swimmer) onSave;

  const AddSwimmerDialog({required this.onSave});

  @override
  _AddSwimmerDialogState createState() => _AddSwimmerDialogState();
}

class _AddSwimmerDialogState extends State<AddSwimmerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _clubController = TextEditingController();
  final _coachController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un Nageur'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom complet'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: 'Date de naissance'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                      _birthDateController.text = date.toString().split(' ')[0];
                    });
                  }
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              TextFormField(
                controller: _clubController,
                decoration: InputDecoration(labelText: 'Club'),
              ),
              TextFormField(
                controller: _coachController,
                decoration: InputDecoration(labelText: 'Entraîneur'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: _saveSwimmer,
          child: Text('Sauvegarder'),
        ),
      ],
    );
  }

  void _saveSwimmer() {
    if (_formKey.currentState!.validate()) {
      final swimmer = Swimmer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        birthDate: _selectedDate,
        category: _categoryController.text,
        club: _clubController.text,
        coach: _coachController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      widget.onSave(swimmer);
      Navigator.of(context).pop();
    }
  }
}

class SwimmerOptionsSheet extends StatelessWidget {
  final Swimmer swimmer;

  const SwimmerOptionsSheet({required this.swimmer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.print),
            title: Text('Imprimer la fiche'),
            onTap: () {
              Navigator.pop(context);
              PrintService.printSwimmerProfile(swimmer);
            },
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Évaluation Physique'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhysicalEvaluationPage(swimmer: swimmer),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pool),
            title: Text('Tests Aquatiques'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AquaticTestPage(swimmer: swimmer),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Métriques Avancées'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdvancedMetricsPage(swimmer: swimmer),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('Objectifs et Suivi'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalsPage(swimmer: swimmer),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
