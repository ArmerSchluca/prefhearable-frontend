import 'package:frontend/utils/input_validator.dart';
import 'package:frontend/utils/session_instance.dart';

class PersonalData {
  int? age;
  Gender? gender;
  Occupation? occupation;
  HearingAided? hearingAided;
  HearingAidDuration? hearingAidDuration;
  ResidentialArea? residentialArea;
  PhysicalActivityType? physicalActivityType;
  PhysicalActivityFrequency? physicalActivityFrequency;
  int? physicalActivityDuration;
  Diet? diet;
  String? allergies;
  String? diseases;

  // Zum Abfragen des Status, ob alle Felder ausgefüllt
  bool get isComplete =>
      InputValidator.validateAge(age) == null &&
      gender != null &&
      occupation != null;
  /*&&
      hearingAided != null &&
      hearingAidSince != null &&
      residentialArea != null &&
      physicalActivityType != null &&
      physicalActivityFrequency != null &&
      physicalActivityDuration != null &&
      diet != null &&
      allergies != null &&
      diseases != null;
      */

  PersonalData({
    this.age,
    this.gender,
    this.occupation,
    this.hearingAided,
    this.hearingAidDuration,
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
    'hearingAidedSince': hearingAidDuration?.name,
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

enum HearingAided { both, leftEar, rightEar, none }

enum HearingAidDuration {
  lessThan6Months,
  sixToTwelveMonths,
  oneToTwoYears,
  twoToFiveYears,
  fiveToTenYears,
  moreThanTenYears,
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

// Zum Anzeigen in der UI
extension PhysicalActivityDurationLabel on PhysicalActivityDuration {
  String get label {
    switch (this) {
      case PhysicalActivityDuration.min30:
        return "30 Minuten";
      case PhysicalActivityDuration.min60:
        return "60 Minuten";
      case PhysicalActivityDuration.min90:
        return "90 Minuten";
      case PhysicalActivityDuration.min120:
        return "120 Minuten";
      case PhysicalActivityDuration.min150:
        return "150 Minuten";
      case PhysicalActivityDuration.min180:
        return "180 Minuten";
    }
  }

  // Zum Speichern der Werte
  int get minutes {
    switch (this) {
      case PhysicalActivityDuration.min30:
        return 30;
      case PhysicalActivityDuration.min60:
        return 60;
      case PhysicalActivityDuration.min90:
        return 90;
      case PhysicalActivityDuration.min120:
        return 120;
      case PhysicalActivityDuration.min150:
        return 150;
      case PhysicalActivityDuration.min180:
        return 180;
    }
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
