import 'package:frontend/models/audiotest_data.dart';
import 'package:frontend/models/context_data.dart';
import 'package:frontend/models/questionnaire_data.dart';
import 'package:frontend/models/personal_data.dart';

class Survey {
  PersonalData? personalData;
  ContextData? contextData;
  QuestionnaireData? questionnaireData;
  AudioTestData? audioTestData;

  Survey({
    this.personalData,
    this.contextData,
    this.questionnaireData,
    this.audioTestData,
  });

  Map<String, dynamic> toJson() => {
    'personalData': personalData?.toJson(),
    'contextData': contextData?.toJson(),
    'questionnaireData': questionnaireData?.toJson(),
    'audioTestData': audioTestData?.toJson(),
  };

  Map<String, dynamic> fromJson(String json) => {};

  bool get isComplete =>
      isPersonalDataComplete &&
      isContextDataComplete &&
      isAudioTestDataComplete &&
      isQuestionnaireDataComplete;

  bool get isPersonalDataComplete =>
      personalData != null && personalData!.isComplete;

  bool get isContextDataComplete =>
      contextData != null && contextData!.isComplete;

  bool get isAudioTestDataComplete =>
      audioTestData != null && audioTestData!.isComplete;

  bool get isQuestionnaireDataComplete =>
      questionnaireData != null && questionnaireData!.isComplete;
}
