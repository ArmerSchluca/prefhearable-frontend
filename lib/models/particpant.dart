import 'package:frontend/models/survey_modules/personal_data.dart';

class Participant {
  String participantId;

  PersonalData personalData;

  Participant({required this.participantId, PersonalData? personalData})
    : personalData = personalData ?? PersonalData();

  Map<String, dynamic> toJson() => {
    'participantId': participantId,
    'personalData': personalData,
  };

  Participant.fromJson(Map<String, dynamic> json)
    : participantId = json['participantId'],
      personalData = PersonalData.fromJson(json['personalData']);
}
