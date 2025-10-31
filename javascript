// Structure racine
users/ {
  userId: {
    email: "entraineur@club.com",
    createdAt: "2024-01-01",
    lastLogin: "2024-01-15"
  }
}

// Sous-collections pour chaque utilisateur
users/{userId}/swimmers/ {
  swimmerId: {
    id: "123456",
    name: "Jean Dupont",
    birthDate: "2005-03-15",
    category: "Junior",
    club: "Racing Club",
    coach: "Marie Martin",
    createdAt: "2024-01-01T10:00:00",
    updatedAt: "2024-01-15T14:30:00"
  }
}

users/{userId}/physicalEvaluations/ {
  evaluationId: {
    id: "eval_123",
    swimmerId: "123456",
    testDate: "2024-01-15",
    weight: 68.5,
    height: 178.0,
    bodyFat: 12.5,
    muscleMass: 45.2,
    pullUps: 15,
    pushUps: 40,
    plankTime: 120,
    squatMax: 85.0,
    shoulderFlexibility: "Bonne",
    hipFlexibility: "Excellente",
    ankleMobility: "Moyenne",
    createdAt: "2024-01-15T14:30:00"
  }
}

users/{userId}/aquaticTests/ {
  testId: {
    id: "test_456",
    swimmerId: "123456",
    testDate: "2024-01-16",
    testType: "competition", // ou "training"
    stroke: "Crawl",
    distance: 100,
    time: "00:58:45",
    strokeRate: 48,
    observations: "Bon départ, virage à améliorer",
    reactionTime: 650,
    turnEfficiency: 7,
    underwaterDistance: 8,
    createdAt: "2024-01-16T09:15:00"
  }
}

users/{userId}/advancedMetrics/ {
  metricId: {
    id: "metric_789",
    swimmerId: "123456",
    testDate: "2024-01-17",
    swolfScore: 35,
    oxygenRate: 95.5,
    powerOutput: 245.8,
    restingHeartRate: 58,
    maxHeartRate: 185,
    recoveryTime: 45,
    createdAt: "2024-01-17T11:20:00"
  }
}

users/{userId}/goals/ {
  goalId: {
    id: "goal_101",
    swimmerId: "123456",
    startDate: "2024-01-15",
    targetDate: "2024-04-15",
    stroke: "Crawl",
    distance: 100,
    currentTime: "01:02:30",
    targetTime: "00:58:00",
    specificGoals: "Améliorer le virage et la respiration",
    trainingPlan: "3 séances techniques par semaine",
    createdAt: "2024-01-15T16:45:00",
    updatedAt: "2024-01-15T16:45:00"
  }
}
