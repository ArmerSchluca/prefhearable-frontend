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

  Set fromJson(Map<String, dynamic> json) => {
    personalData = json['personalData'] as PersonalData,
    contextData = json['contextData'] as ContextData,
    questionnaireData = json['questionnaireData'] as QuestionnaireData,
    audioTestData = json['audioTestData'] as AudioTestData,
  };

  bool get isComplete =>
      personalData.isComplete &&
      contextData.isComplete &&
      audioTestData.isComplete &&
      questionnaireData.isComplete;
}
