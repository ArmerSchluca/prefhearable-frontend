import 'package:frontend/utils/session_instance.dart';

class PersonalData {
  int? age;
  Gender? gender;
  Occupation? occupation;
  HearingAided? hearingAided;
  DateTime? hearingAidSince;
  ResidentialArea? residentialArea;
  PhysicalActivityType? physicalActivityType;
  PhysicalActivityFrequency? physicalActivityFrequency;
  int? physicalActivityDuration;
  Diet? diet;
  String? allergies;
  String? diseases;

  // Zum Abfragen des Status, ob alle Felder ausgefüllt
  bool get isComplete =>
      age != null &&
      gender != null &&
      occupation != null &&
      hearingAided != null &&
      hearingAidSince != null &&
      residentialArea != null &&
      physicalActivityType != null &&
      physicalActivityFrequency != null &&
      physicalActivityDuration != null &&
      diet != null &&
      allergies != null &&
      diseases != null;

  PersonalData({
    this.age,
    this.gender,
    this.occupation,
    this.hearingAided,
    this.hearingAidSince,
    this.residentialArea,
    this.physicalActivityType,
    this.physicalActivityFrequency,
    this.physicalActivityDuration,
    this.diet,
    this.allergies,
    this.diseases,
  });

  Map<String, dynamic> toJson() => {
    'id': session.getCurrentParticipantId(),
    'age': age,
    'gender': gender?.name,
    'occupation': occupation?.name,
    'hearingAided': hearingAided?.name,
    'hearingAidedSince': hearingAidSince?.toIso8601String(),
    'residentialArea': residentialArea?.name,
    'physicalActivityType': physicalActivityType?.name,
    'physicalActivityFrequency': physicalActivityFrequency?.name,
    'physicalActivityDuration': physicalActivityDuration,
    'diet': diet?.name,
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
