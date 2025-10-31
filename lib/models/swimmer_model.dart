class Swimmer {
  String id;
  String name;
  DateTime birthDate;
  String category;
  String club;
  String coach;
  DateTime createdAt;
  DateTime updatedAt;

  Swimmer({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.category,
    required this.club,
    required this.coach,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'category': category,
      'club': club,
      'coach': coach,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Swimmer.fromJson(Map<String, dynamic> json) {
    return Swimmer(
      id: json['id'],
      name: json['name'],
      birthDate: DateTime.parse(json['birthDate']),
      category: json['category'],
      club: json['club'],
      coach: json['coach'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PhysicalEvaluation {
  String id;
  String swimmerId;
  DateTime testDate;
  double weight;
  double height;
  double bodyFat;
  double muscleMass;
  int pullUps;
  int pushUps;
  int plankTime;
  double squatMax;
  String shoulderFlexibility;
  String hipFlexibility;
  String ankleMobility;

  PhysicalEvaluation({
    required this.id,
    required this.swimmerId,
    required this.testDate,
    required this.weight,
    required this.height,
    required this.bodyFat,
    required this.muscleMass,
    required this.pullUps,
    required this.pushUps,
    required this.plankTime,
    required this.squatMax,
    required this.shoulderFlexibility,
    required this.hipFlexibility,
    required this.ankleMobility,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'swimmerId': swimmerId,
      'testDate': testDate.toIso8601String(),
      'weight': weight,
      'height': height,
      'bodyFat': bodyFat,
      'muscleMass': muscleMass,
      'pullUps': pullUps,
      'pushUps': pushUps,
      'plankTime': plankTime,
      'squatMax': squatMax,
      'shoulderFlexibility': shoulderFlexibility,
      'hipFlexibility': hipFlexibility,
      'ankleMobility': ankleMobility,
    };
  }

  factory PhysicalEvaluation.fromJson(Map<String, dynamic> json) {
    return PhysicalEvaluation(
      id: json['id'],
      swimmerId: json['swimmerId'],
      testDate: DateTime.parse(json['testDate']),
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      bodyFat: json['bodyFat'].toDouble(),
      muscleMass: json['muscleMass'].toDouble(),
      pullUps: json['pullUps'],
      pushUps: json['pushUps'],
      plankTime: json['plankTime'],
      squatMax: json['squatMax'].toDouble(),
      shoulderFlexibility: json['shoulderFlexibility'],
      hipFlexibility: json['hipFlexibility'],
      ankleMobility: json['ankleMobility'],
    );
  }
}

class AquaticTest {
  String id;
  String swimmerId;
  DateTime testDate;
  String testType; // 'training' or 'competition'
  String stroke;
  int distance;
  String time;
  int strokeRate;
  String observations;
  int reactionTime;
  int turnEfficiency;
  int underwaterDistance;

  AquaticTest({
    required this.id,
    required this.swimmerId,
    required this.testDate,
    required this.testType,
    required this.stroke,
    required this.distance,
    required this.time,
    required this.strokeRate,
    required this.observations,
    required this.reactionTime,
    required this.turnEfficiency,
    required this.underwaterDistance,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'swimmerId': swimmerId,
      'testDate': testDate.toIso8601String(),
      'testType': testType,
      'stroke': stroke,
      'distance': distance,
      'time': time,
      'strokeRate': strokeRate,
      'observations': observations,
      'reactionTime': reactionTime,
      'turnEfficiency': turnEfficiency,
      'underwaterDistance': underwaterDistance,
    };
  }

  factory AquaticTest.fromJson(Map<String, dynamic> json) {
    return AquaticTest(
      id: json['id'],
      swimmerId: json['swimmerId'],
      testDate: DateTime.parse(json['testDate']),
      testType: json['testType'],
      stroke: json['stroke'],
      distance: json['distance'],
      time: json['time'],
      strokeRate: json['strokeRate'],
      observations: json['observations'],
      reactionTime: json['reactionTime'],
      turnEfficiency: json['turnEfficiency'],
      underwaterDistance: json['underwaterDistance'],
    );
  }
}

class AdvancedMetrics {
  String id;
  String swimmerId;
  DateTime testDate;
  int swolfScore;
  double oxygenRate;
  double powerOutput;
  int restingHeartRate;
  int maxHeartRate;
  int recoveryTime;

  AdvancedMetrics({
    required this.id,
    required this.swimmerId,
    required this.testDate,
    required this.swolfScore,
    required this.oxygenRate,
    required this.powerOutput,
    required this.restingHeartRate,
    required this.maxHeartRate,
    required this.recoveryTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'swimmerId': swimmerId,
      'testDate': testDate.toIso8601String(),
      'swolfScore': swolfScore,
      'oxygenRate': oxygenRate,
      'powerOutput': powerOutput,
      'restingHeartRate': restingHeartRate,
      'maxHeartRate': maxHeartRate,
      'recoveryTime': recoveryTime,
    };
  }

  factory AdvancedMetrics.fromJson(Map<String, dynamic> json) {
    return AdvancedMetrics(
      id: json['id'],
      swimmerId: json['swimmerId'],
      testDate: DateTime.parse(json['testDate']),
      swolfScore: json['swolfScore'],
      oxygenRate: json['oxygenRate'].toDouble(),
      powerOutput: json['powerOutput'].toDouble(),
      restingHeartRate: json['restingHeartRate'],
      maxHeartRate: json['maxHeartRate'],
      recoveryTime: json['recoveryTime'],
    );
  }
}

class Goals {
  String id;
  String swimmerId;
  DateTime startDate;
  DateTime targetDate;
  String stroke;
  int distance;
  String currentTime;
  String targetTime;
  String specificGoals;
  String trainingPlan;

  Goals({
    required this.id,
    required this.swimmerId,
    required this.startDate,
    required this.targetDate,
    required this.stroke,
    required this.distance,
    required this.currentTime,
    required this.targetTime,
    required this.specificGoals,
    required this.trainingPlan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'swimmerId': swimmerId,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'stroke': stroke,
      'distance': distance,
      'currentTime': currentTime,
      'targetTime': targetTime,
      'specificGoals': specificGoals,
      'trainingPlan': trainingPlan,
    };
  }

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      id: json['id'],
      swimmerId: json['swimmerId'],
      startDate: DateTime.parse(json['startDate']),
      targetDate: DateTime.parse(json['targetDate']),
      stroke: json['stroke'],
      distance: json['distance'],
      currentTime: json['currentTime'],
      targetTime: json['targetTime'],
      specificGoals: json['specificGoals'],
      trainingPlan: json['trainingPlan'],
    );
  }
}
