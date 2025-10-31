import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/swimmer_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // === GESTION DES NAGEURS ===
  Future<void> addSwimmer(Swimmer swimmer) async {
    if (currentUserId == null) return;
    
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('swimmers')
        .doc(swimmer.id)
        .set(swimmer.toJson());
  }

  Stream<List<Swimmer>> getSwimmersStream() {
    if (currentUserId == null) return Stream.value([]);
    
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('swimmers')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Swimmer.fromJson(doc.data()))
            .toList());
  }

  // === GESTION DES ÉVALUATIONS PHYSIQUES ===
  Future<void> addPhysicalEvaluation(PhysicalEvaluation evaluation) async {
    if (currentUserId == null) return;
    
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('physicalEvaluations')
        .doc(evaluation.id)
        .set(evaluation.toJson());
  }
}
