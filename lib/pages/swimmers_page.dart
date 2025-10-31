// AJOUTER EN HAUT DU FICHIER
import '../services/firestore_service.dart';
import '../models/swimmer_model.dart';

// MODIFIER LA CLASE POUR INCLURE FIREBASE
class _SwimmersPageState extends State<SwimmersPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Swimmer> _swimmers = [];

  @override
  void initState() {
    super.initState();
    _loadSwimmers();
  }

  void _loadSwimmers() {
    // Écouter les données Firestore
    _firestoreService.getSwimmersStream().listen((swimmers) {
      setState(() {
        _swimmers = swimmers;
      });
    });
  }

  void _addSwimmer() {
    showDialog(
      context: context,
      builder: (context) => AddSwimmerDialog(
        onSave: (swimmer) {
          _firestoreService.addSwimmer(swimmer);
        },
      ),
    );
  }
}
