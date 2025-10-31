class AddSwimmerPage extends StatefulWidget {
  @override
  _AddSwimmerPageState createState() => _AddSwimmerPageState();
}

class _AddSwimmerPageState extends State<AddSwimmerPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  void _saveSwimmer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final swimmerData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'birthDate': _birthDate,
        'category': _categoryController.text,
        'club': _clubController.text,
        'coach': _coachController.text,
      };

      try {
        await _firestoreService.addSwimmer(swimmerData);
        Navigator.pop(context); // Retour à la liste
      } catch (e) {
        print('Erreur: $e');
      }
    }
  }
}
