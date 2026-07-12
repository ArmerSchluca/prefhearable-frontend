import 'package:frontend/models/device_information.dart';
import 'package:frontend/models/survey_modules/audiotest_data.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/models/survey_modules/questionnaire_data.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';

class Survey {
  bool readOnly = false;

  final String surveyVersion = "1.0.0";

  DateTime startedAt = DateTime.now();
  DateTime? finishedAt;

  DeviceInformation deviceInformation = DeviceInformation();

  PersonalData personalData = PersonalData();
  ContextData contextData = ContextData();
  QuestionnaireData questionnaireData = QuestionnaireData();
  AudioTestData audioTestData = AudioTestData();

  Survey();

  Survey.fromJson(Map<String, dynamic> json) {
    startedAt = DateTime.parse(json['startedAt']);
    finishedAt = json['finishedAt'] != null
        ? DateTime.parse(json['finishedAt'])
        : null;
    deviceInformation = DeviceInformation.fromJson(json['deviceInformation']);
    personalData = PersonalData.fromJson(json['personalData']);
    contextData = ContextData.fromJson(json['contextData']);
    questionnaireData = QuestionnaireData.fromJson(json['questionnaireData']);
    audioTestData = AudioTestData.fromJson(json['audioTestData']);
  }

  Map<String, dynamic> toJson() => {
    'surveyVersion': surveyVersion,
    'startedAt': startedAt.toIso8601String(),
    'finishedAt': finishedAt?.toIso8601String(),
    'deviceInformation': deviceInformation,
    'personalData': personalData,
    'contextData': contextData,
    'questionnaireData': questionnaireData,
    'audioTestData': audioTestData,
  };

  bool get isComplete =>
      personalData.isComplete &&
      contextData.isComplete &&
      audioTestData.isComplete &&
      questionnaireData.isComplete;
}
