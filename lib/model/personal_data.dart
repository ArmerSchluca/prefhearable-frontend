import 'package:frontend/util/session.dart';

class PersonalData {
  int age;
  Gender gender;
  Occupation occupation;
  HearingAided hearingAided;
  DateTime? hearingAidSince;
  ResidentialArea residentialArea;
  PhysicalActivityType physicalActivityType;
  PhysicalActivityFrequency physicalActivityFrequency;
  int physicalActivityDuration;
  Diet diet;
  List<String> allergies;
  List<String> diseases;

  PersonalData({
    required this.age,
    required this.gender,
    required this.occupation,
    required this.hearingAided,
    this.hearingAidSince,
    required this.residentialArea,
    required this.physicalActivityType,
    required this.physicalActivityFrequency,
    required this.physicalActivityDuration,
    required this.diet,
    required this.allergies,
    required this.diseases,
  });

  Map<String, dynamic> toJson() => {
    'id': session.getCurrentParticipantId(),
    'age': age,
    'gender': gender.name,
    'occupation': occupation.name,
    'hearingAided': hearingAided.name,
    'hearingAidedSince': hearingAidSince?.toIso8601String(),
    'residentialArea': residentialArea.name,
    'physicalActivityType': physicalActivityType.name,
    'physicalActivityFrequency': physicalActivityFrequency.name,
    'physicalActivityDuration': physicalActivityDuration,
    'diet': diet.name,
    'allergies': allergies,
    'diseases': diseases,
  };
}

enum Gender { male, female, diverse }

enum Occupation {
  student,
  office,
  manualLabor,
  healthcare,
  education,
  unemployed,
  retired,
  other,
}

enum HearingAided { no, leftEar, rightEar, both }

enum ResidentialArea { urban, suburban, rural }

enum PhysicalActivityType { endurance, strength, combined, team, other, none }

enum PhysicalActivityFrequency {
  never,
  oneToTwoPerWeek,
  threeToFourPerWeek,
  fivePlusPerWeek,
}

const physicalActivityDuration = [30, 60, 90, 120, 150, 180];

enum Diet { omnivore, vegetarian, vegan, pescetarian, other }
