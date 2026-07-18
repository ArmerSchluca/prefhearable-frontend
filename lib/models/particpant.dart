import 'package:frontend/models/survey_modules/personal_data.dart';

class Participant {
  // Dient dazu, dass Personaldata selbst nach Abschluss einer
  // Survey an diesem Objekt gespeichert bleibt
  PersonalData personalData;

  Participant({PersonalData? personalData})
    : personalData = personalData ?? PersonalData();

  Map<String, dynamic> toJson() => {'personalData': personalData};

  Participant.fromJson(Map<String, dynamic> json)
    : personalData = PersonalData.fromJson(json['personalData']);
}
