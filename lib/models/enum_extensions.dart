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
      case SectionStatus.open:
        return "Offen";
      case SectionStatus.partial:
        return "Teilweise";
      case SectionStatus.completed:
        return "Abgeschlossen";
    }
  }
}
