import 'package:frontend/models/device_information.dart';
import 'package:frontend/models/survey_modules/audiotest_data.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/models/survey_modules/questionnaire_data.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';

class Survey {
  final String surveyVersion = "1.0.0";

  DateTime startedAt = DateTime.now();
  DateTime? finishedAt;

  DeviceInformation deviceInformation = DeviceInformation();

  PersonalData personalData = PersonalData();
  ContextData contextData = ContextData();
  QuestionnaireData questionnaireData = QuestionnaireData();
  AudioTestData audioTestData = AudioTestData();

  Map<String, dynamic> toJson() => {
    'survey_version': surveyVersion,
    'started_at': startedAt.toIso8601String(),
    'finished_at': finishedAt?.toIso8601String(),
    'deviceInfo': deviceInformation,
    'personal_data': personalData,
    'context_data': contextData,
    'questionnaire_data': questionnaireData,
    'audio_test_data': audioTestData,
  };

  Set fromJson(Map<String, dynamic> json) => {
    personalData = json['personal_data'] as PersonalData,
    contextData = json['context_data'] as ContextData,
    questionnaireData = json['questionnaire_data'] as QuestionnaireData,
    audioTestData = json['audio_test_data'] as AudioTestData,
  };

  bool get isComplete =>
      personalData.isComplete &&
      contextData.isComplete &&
      audioTestData.isComplete &&
      questionnaireData.isComplete;
}
