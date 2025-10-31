rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Chaque utilisateur ne peut accéder qu'à ses propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /swimmers/{swimmerId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /physicalEvaluations/{evalId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /aquaticTests/{testId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /advancedMetrics/{metricId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /goals/{goalId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
