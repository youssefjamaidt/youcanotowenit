// CONTENU COMPLET À AJOUTER
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
}
