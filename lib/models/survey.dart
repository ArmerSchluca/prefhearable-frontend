import 'package:frontend/models/audiotest_data.dart';
import 'package:frontend/models/context_data.dart';
import 'package:frontend/models/questionnaire_data.dart';
import 'package:frontend/models/personal_data.dart';

class Survey {
  final PersonalData personalData;
  final ContextData contextData;
  final QuestionnaireData questionnaireData;
  final AudioTestData audioTestData;

  Survey({
    required this.personalData,
    required this.contextData,
    required this.questionnaireData,
    required this.audioTestData,
  });

  Map<String, dynamic> toJson() => {
    'personalData': personalData.toJson(),
    'contextData': contextData.toJson(),
    'questionnaireData': questionnaireData.toJson(),
    'audioTestData': audioTestData.toJson(),
  };
}
