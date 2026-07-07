import 'package:frontend/models/survey_modules/audiotest_data.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/models/survey_modules/questionnaire_data.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';

class Survey {
  PersonalData personalData = PersonalData();
  ContextData contextData = ContextData();
  QuestionnaireData questionnaireData = QuestionnaireData();
  AudioTestData audioTestData = AudioTestData();

  Map<String, dynamic> toJson() => {
    'personalData': personalData.toJson(),
    'contextData': contextData.toJson(),
    'questionnaireData': questionnaireData.toJson(),
    'audioTestData': audioTestData.toJson(),
  };

  Map<String, dynamic> fromJson(String json) => {};

  bool get isComplete =>
      personalData.isComplete &&
      contextData.isComplete &&
      audioTestData.isComplete &&
      questionnaireData.isComplete;
}
