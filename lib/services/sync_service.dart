import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/swimmer_model.dart';
import '../models/physical_evaluation_model.dart';
import '../models/aquatic_test_model.dart';
import '../models/advanced_metrics_model.dart';
import '../models/goals_model.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Récupérer l'ID utilisateur courant
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Vérifier la connexion
  bool get isConnected => currentUserId != null;

  // === SYNCHRONISATION AUTOMATIQUE ===
  
  Future<void> autoSyncSwimmer(Swimmer swimmer) async {
    if (!isConnected) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('swimmers')
          .doc(swimmer.id)
          .set(swimmer.toJson(), SetOptions(merge: true));
          
      print('✅ Nageur synchronisé: ${swimmer.name}');
    } catch (e) {
      print('❌ Erreur sync nageur: $e');
      // Sauvegarde locale pour sync plus tard
      await _saveForLaterSync('swimmers', swimmer.toJson());
    }
  }

  Future<void> autoSyncPhysicalEvaluation(PhysicalEvaluation evaluation) async {
    if (!isConnected) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('physicalEvaluations')
          .doc(evaluation.id)
          .set(evaluation.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('❌ Erreur sync évaluation: $e');
      await _saveForLaterSync('physicalEvaluations', evaluation.toJson());
    }
  }

  Future<void> autoSyncAquaticTest(AquaticTest test) async {
    if (!isConnected) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('aquaticTests')
          .doc(test.id)
          .set(test.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('❌ Erreur sync test aquatique: $e');
      await _saveForLaterSync('aquaticTests', test.toJson());
    }
  }

  // === SYNCHRONISATION MANUELLE ===
  
  Future<void> manualSyncAllData() async {
    if (!isConnected) {
      throw Exception('Non connecté à Internet');
    }
    
    try {
      // 1. Synchroniser les données en attente
      await _syncPendingData();
      
      // 2. Récupérer les dernières données du cloud
      await _downloadLatestData();
      
      print('🔄 Synchronisation manuelle terminée');
    } catch (e) {
      print('❌ Erreur sync manuelle: $e');
      rethrow;
    }
  }

  // === GESTION DES CONFLITS ===
  
  Future<void> _resolveConflict(String collection, String docId, Map<String, dynamic> localData, Map<String, dynamic> cloudData) async {
    // Stratégie : dernière modification gagne
    final DateTime localUpdate = DateTime.parse(localData['updatedAt']);
    final DateTime cloudUpdate = DateTime.parse(cloudData['updatedAt']);
    
    if (localUpdate.isAfter(cloudUpdate)) {
      // La version locale est plus récente
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection(collection)
          .doc(docId)
          .set(localData);
    } else {
      // La version cloud est plus récente - on garde le cloud
      // On pourrait notifier l'utilisateur du conflit
      print('⚡ Conflit résolu: version cloud gardée pour $docId');
    }
  }

  // === MODE HORS LIGNE ===
  
  Future<void> _saveForLaterSync(String collection, Map<String, dynamic> data) async {
    // Sauvegarde dans la base locale (Hive ou Sembast)
    final pendingSyncs = await _getPendingSyncs();
    pendingSyncs.add({
      'collection': collection,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _savePendingSyncs(pendingSyncs);
  }

  Future<void> _syncPendingData() async {
    final pendingSyncs = await _getPendingSyncs();
    
    for (final sync in pendingSyncs) {
      try {
        final collection = sync['collection'] as String;
        final data = sync['data'] as Map<String, dynamic>;
        
        switch (collection) {
          case 'swimmers':
            await _firestore
                .collection('users')
                .doc(currentUserId)
                .collection('swimmers')
                .doc(data['id'])
                .set(data, SetOptions(merge: true));
            break;
          case 'physicalEvaluations':
            await _firestore
                .collection('users')
                .doc(currentUserId)
                .collection('physicalEvaluations')
                .doc(data['id'])
                .set(data, SetOptions(merge: true));
            break;
          // ... autres collections
        }
        
        // Retirer de la liste des pending
        pendingSyncs.remove(sync);
      } catch (e) {
        print('❌ Erreur sync pending: $e');
      }
    }
    
    await _savePendingSyncs(pendingSyncs);
  }

  // === TÉLÉCHARGEMENT DES DONNÉES ===
  
  Future<void> _downloadLatestData() async {
    // Télécharger tous les nageurs
    final swimmersSnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('swimmers')
        .get();
    
    for (final doc in swimmersSnapshot.docs) {
      // Mettre à jour la base locale
      await _updateLocalData('swimmers', doc.id, doc.data());
    }
    
    // Répéter pour les autres collections...
  }

  // === MÉTHODES UTILITAIRES ===
  
  Future<List<Map<String, dynamic>>> _getPendingSyncs() async {
    // Implémentation avec la base locale
    // Retourne une liste vide pour l'exemple
    return [];
  }
  
  Future<void> _savePendingSyncs(List<Map<String, dynamic>> syncs) async {
    // Implémentation avec la base locale
  }
  
  Future<void> _updateLocalData(String collection, String id, Map<String, dynamic> data) async {
    // Mettre à jour la base de données locale
  }

  // === STREAMS POUR TEMPS RÉEL ===
  
  Stream<List<Swimmer>> getSwimmersStream() {
    if (!isConnected) {
      return Stream.value([]); // Retourner données locales
    }
    
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('swimmers')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Swimmer.fromJson(doc.data()))
            .toList())
        .handleError((error) {
          print('❌ Erreur stream swimmers: $error');
          return [];
        });
  }

  Stream<List<PhysicalEvaluation>> getPhysicalEvaluationsStream(String swimmerId) {
    if (!isConnected) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('physicalEvaluations')
        .where('swimmerId', isEqualTo: swimmerId)
        .orderBy('testDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PhysicalEvaluation.fromJson(doc.data()))
            .toList());
  }
}
