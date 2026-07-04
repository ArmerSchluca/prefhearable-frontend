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
