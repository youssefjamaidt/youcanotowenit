import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser!.uid;

  // === CRUD pour les Nageurs ===
  
  Future<void> addSwimmer(Map<String, dynamic> swimmerData) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('swimmers')
        .doc(swimmerData['id'])
        .set({
          ...swimmerData,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> updateSwimmer(String swimmerId, Map<String, dynamic> updates) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('swimmers')
        .doc(swimmerId)
        .update({
          ...updates,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> getSwimmersStream() {
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('swimmers')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // === CRUD pour Évaluations Physiques ===
  
  Future<void> addPhysicalEvaluation(Map<String, dynamic> evaluationData) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('physicalEvaluations')
        .doc(evaluationData['id'])
        .set({
          ...evaluationData,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> getPhysicalEvaluationsStream(String swimmerId) {
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('physicalEvaluations')
        .where('swimmerId', isEqualTo: swimmerId)
        .orderBy('testDate', descending: true)
        .snapshots();
  }

  // === CRUD pour Tests Aquatiques ===
  
  Future<void> addAquaticTest(Map<String, dynamic> testData) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('aquaticTests')
        .doc(testData['id'])
        .set({
          ...testData,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  // === CRUD pour Métriques Avancées ===
  
  Future<void> addAdvancedMetrics(Map<String, dynamic> metricsData) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('advancedMetrics')
        .doc(metricsData['id'])
        .set({
          ...metricsData,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  // === CRUD pour Objectifs ===
  
  Future<void> addGoal(Map<String, dynamic> goalData) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('goals')
        .doc(goalData['id'])
        .set({
          ...goalData,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  // === Méthodes Utilitaires ===
  
  Future<DocumentSnapshot> getSwimmer(String swimmerId) async {
    return await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('swimmers')
        .doc(swimmerId)
        .get();
  }

  Future<void> deleteSwimmer(String swimmerId) async {
    await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('swimmers')
        .doc(swimmerId)
        .delete();
  }
}
