import 'package:frontend/utils/survey_instance.dart';

class PersonalData {
  int? age;
  Gender? gender;
  Occupation? occupation;

  HearingAided? hearingAided;
  HearingAidDuration? hearingAidDuration;
  HearingAidType? hearingAidType;

  ResidentialArea? residentialArea;

  PhysicalActivityType? physicalActivityType;
  PhysicalActivityFrequency? physicalActivityFrequency;
  PhysicalActivityDuration? physicalActivityDuration;

  Diet? diet;
  String? allergies;
  String? diseases;

  // Zum Abfragen des Status, ob alle Felder ausgefüllt
  bool get isComplete =>
      surveyService.validateAge(age) == null &&
      gender != null &&
      occupation != null &&
      isHearingAidComplete &&
      residentialArea != null &&
      isSportComplete &&
      diet != null;
  // allergies und diseases nicht verpflichtend

  // Wenn Sport = none oder null ist, sollen beide anderen Felder null sein
  bool get isSportRequired => physicalActivityType != PhysicalActivityType.none;
  bool get isSportComplete {
    if (!isSportRequired) return true;
    return physicalActivityFrequency != null &&
        physicalActivityDuration != null;
  }

  // Wenn HearingAided = none oder null ist, soll auch HearingAidDuration null sein
  bool get isHearingAided => hearingAided != HearingAided.none;
  bool get isHearingAidComplete {
    if (!isHearingAided) return true;
    return hearingAidDuration != null && hearingAidType != null;
  }

  PersonalData({
    this.age,
    this.gender,
    this.occupation,
    this.hearingAided,
    this.hearingAidDuration,
    this.hearingAidType,
    this.residentialArea,
    this.physicalActivityType,
    this.physicalActivityFrequency,
    this.physicalActivityDuration,
    this.diet,
    this.allergies,
    this.diseases,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'gender': gender?.name,
    'occupation': occupation?.name,
    'hearingAided': hearingAided?.name,
    'hearingAidDuration': hearingAidDuration?.name,
    'hearingAidType': hearingAidType?.name,
    'residentialArea': residentialArea?.name,
    'physicalActivityType': physicalActivityType?.name,
    'physicalActivityFrequency': physicalActivityFrequency?.name,
    'physicalActivityDuration': physicalActivityDuration?.minutes,
    'diet': diet?.name,
    'allergies': allergies,
    'diseases': diseases,
  };

  PersonalData.fromJson(Map<String, dynamic> json) {
    age = json['age'];

    gender = json['gender'] != null
        ? Gender.values.firstWhere((e) => e.name == json['gender'])
        : null;

    occupation = json['occupation'] != null
        ? Occupation.values.firstWhere((e) => e.name == json['occupation'])
        : null;

    hearingAided = json['hearingAided'] != null
        ? HearingAided.values.firstWhere((e) => e.name == json['hearingAided'])
        : null;

    hearingAidDuration = json['hearingAidDuration'] != null
        ? HearingAidDuration.values.firstWhere(
            (e) => e.name == json['hearingAidDuration'],
          )
        : null;

    hearingAidType = json['hearingAidType'] != null
        ? HearingAidType.values.firstWhere(
            (e) => e.name == json['hearingAidType'],
          )
        : null;

    residentialArea = json['residentialArea'] != null
        ? ResidentialArea.values.firstWhere(
            (e) => e.name == json['residentialArea'],
          )
        : null;

    physicalActivityType = json['physicalActivityType'] != null
        ? PhysicalActivityType.values.firstWhere(
            (e) => e.name == json['physicalActivityType'],
          )
        : null;

    physicalActivityFrequency = json['physicalActivityFrequency'] != null
        ? PhysicalActivityFrequency.values.firstWhere(
            (e) => e.name == json['physicalActivityFrequency'],
          )
        : null;

    physicalActivityDuration = json['physicalActivityDuration'] != null
        ? PhysicalActivityDuration.values.firstWhere(
            (e) => e.minutes == json['physicalActivityDuration'],
          )
        : null;

    diet = json['diet'] != null
        ? Diet.values.firstWhere((e) => e.name == json['diet'])
        : null;

    allergies = json['allergies'];
    diseases = json['diseases'];
  }
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

enum HearingAided { both, leftEar, rightEar, none }

enum HearingAidDuration {
  lessThan6Months,
  sixToTwelveMonths,
  oneToTwoYears,
  twoToFiveYears,
  fiveToTenYears,
  moreThanTenYears,
}

enum HearingAidType {
  behindTheEar,
  inTheEar,
  cochlearImplant,
  boneConduction,
  other,
}

enum ResidentialArea { urban, suburban, rural }

enum PhysicalActivityType { endurance, strength, combined, team, other, none }

enum PhysicalActivityFrequency {
  oneToTwoPerWeek,
  threeToFourPerWeek,
  fivePlusPerWeek,
}

enum PhysicalActivityDuration { min30, min60, min90, min120, min150, min180 }

enum Diet { omnivore, vegetarian, vegan, other }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return "Männlich";
      case Gender.female:
        return "Weiblich";
      case Gender.diverse:
        return "Divers";
    }
  }
}

extension OccupationLabel on Occupation {
  String get label {
    switch (this) {
      case Occupation.student:
        return "StudentIn/SchülerIn";
      case Occupation.office:
        return "Büro";
      case Occupation.manualLabor:
        return "Handwerk";
      case Occupation.healthcare:
        return "Pflege";
      case Occupation.education:
        return "Lehre";
      case Occupation.unemployed:
        return "Arbeitslos";
      case Occupation.retired:
        return "RentnerIn";
      case Occupation.other:
        return "Sonstige";
    }
  }
}

extension HearingAidedLabel on HearingAided {
  String get label {
    switch (this) {
      case HearingAided.both:
        return "Beidseitig";
      case HearingAided.leftEar:
        return "Nur linkes Ohr";
      case HearingAided.rightEar:
        return "Nur rechts Ohr";
      case HearingAided.none:
        return "Keine";
    }
  }
}

extension HearingAidDurationLabel on HearingAidDuration {
  String get label {
    switch (this) {
      case HearingAidDuration.lessThan6Months:
        return "Weniger als 6 Monate";
      case HearingAidDuration.sixToTwelveMonths:
        return "6–12 Monate";
      case HearingAidDuration.oneToTwoYears:
        return "1–2 Jahre";
      case HearingAidDuration.twoToFiveYears:
        return "2–5 Jahre";
      case HearingAidDuration.fiveToTenYears:
        return "5–10 Jahre";
      case HearingAidDuration.moreThanTenYears:
        return "Mehr als 10 Jahre";
    }
  }
}

extension HearingAidTypeLabel on HearingAidType {
  String get label {
    switch (this) {
      case HearingAidType.behindTheEar:
        return "Hinter-dem-Ohr (HdO)";

      case HearingAidType.inTheEar:
        return "Im-Ohr (IdO)";

      case HearingAidType.cochlearImplant:
        return "Cochlea-Implantat (CI)";

      case HearingAidType.boneConduction:
        return "Knochenleitungs-Hörsystem";

      case HearingAidType.other:
        return "Andere Hörhilfe";
    }
  }
}

extension ResidentialAreaLabel on ResidentialArea {
  String get label {
    switch (this) {
      case ResidentialArea.urban:
        return "Städtisch";
      case ResidentialArea.suburban:
        return "Vorstädtisch";
      case ResidentialArea.rural:
        return "Ländlich";
    }
  }
}

extension PhysicalActivityTypeLabel on PhysicalActivityType {
  String get label {
    switch (this) {
      case PhysicalActivityType.endurance:
        return "Ausdauersport";
      case PhysicalActivityType.strength:
        return "Kraftsport";
      case PhysicalActivityType.combined:
        return "Kraft-/Ausdauersport";
      case PhysicalActivityType.team:
        return "Teamsport";
      case PhysicalActivityType.other:
        return "Sonstige";
      case PhysicalActivityType.none:
        return "Keine";
    }
  }
}

extension PhysicalActivityFrequencyLabel on PhysicalActivityFrequency {
  String get label {
    switch (this) {
      case PhysicalActivityFrequency.oneToTwoPerWeek:
        return "1-2 Mal pro Woche";
      case PhysicalActivityFrequency.threeToFourPerWeek:
        return "3-4 Mal pro Woche";
      case PhysicalActivityFrequency.fivePlusPerWeek:
        return "5+ Mal pro Woche";
    }
  }
}

extension PhysicalActivityDurationExtension on PhysicalActivityDuration {
  String get label => "$minutes Minuten";

  int get minutes {
    return switch (this) {
      PhysicalActivityDuration.min30 => 30,
      PhysicalActivityDuration.min60 => 60,
      PhysicalActivityDuration.min90 => 90,
      PhysicalActivityDuration.min120 => 120,
      PhysicalActivityDuration.min150 => 150,
      PhysicalActivityDuration.min180 => 180,
    };
  }
}

extension DietLabel on Diet {
  String get label {
    switch (this) {
      case Diet.omnivore:
        return "Omnivore";
      case Diet.vegetarian:
        return "Vegetarisch";
      case Diet.vegan:
        return "Vegan";
      case Diet.other:
        return "Sonstige";
    }
  }
}
