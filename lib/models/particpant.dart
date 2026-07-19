import 'package:frontend/models/survey_modules/personal_data.dart';

class Participant {
  final String? id;
  PersonalData personalData;

  Participant({this.id, PersonalData? personalData})
    : personalData = personalData ?? PersonalData();

  Map<String, dynamic> toJson() => {
    'id': id,
    'personalData': personalData.toJson(),
  };

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      personalData: PersonalData.fromJson(json['personalData']),
    );
  }
}
