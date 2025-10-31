import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/swimmer_model.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Synchroniser un nageur
  Future<void> syncSwimmer(Swimmer swimmer) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('swimmers')
            .doc(swimmer.id)
            .set(swimmer.toJson());
      }
    } catch (e) {
      print('Erreur synchronisation nageur: $e');
    }
  }

  // Synchroniser évaluation physique
  Future<void> syncPhysicalEvaluation(PhysicalEvaluation evaluation) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('physicalEvaluations')
            .doc(evaluation.id)
            .set(evaluation.toJson());
      }
    } catch (e) {
      print('Erreur synchronisation évaluation: $e');
    }
  }

  // Synchroniser tests aquatiques
  Future<void> syncAquaticTest(AquaticTest test) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('aquaticTests')
            .doc(test.id)
            .set(test.toJson());
      }
    } catch (e) {
      print('Erreur synchronisation test aquatique: $e');
    }
  }

  // Récupérer tous les nageurs
  Stream<List<Swimmer>> getSwimmersStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('swimmers')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Swimmer.fromJson(doc.data()))
              .toList());
    }
    return Stream.value([]);
  }
}
