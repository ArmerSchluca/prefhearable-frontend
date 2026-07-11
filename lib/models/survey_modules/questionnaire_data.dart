import 'package:frontend/models/survey_modules/questionnaires/eq5d.dart';
import 'package:frontend/models/survey_modules/questionnaires/who5.dart';

class QuestionnaireData {
  Eq5d eq5d = Eq5d();
  Who5 who5 = Who5();

  bool get isComplete => eq5d.isComplete && who5.isComplete;

  Map<String, dynamic> toJson() => {
    'eq5dResponses': eq5d.toJson(),
    'who5Responses': who5.toJson(),
  };
}
