import 'package:frontend/models/personal_data.dart';
import 'package:frontend/views/survey_view.dart';

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
        return "";
      case Occupation.unemployed:
        return "Arbeitslos";
      case Occupation.retired:
        return "RentnerIn";
      case Occupation.other:
        return "Sonstige";
    }
  }
}

extension StatusLabel on SectionStatus {
  String get label {
    switch (this) {
      case SectionStatus.incomplete:
        return "Offen";
      case SectionStatus.complete:
        return "Erfasst";
    }
  }
}
