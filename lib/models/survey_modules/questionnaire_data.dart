import 'package:frontend/models/survey_modules/questionnaires/eq5d.dart';
import 'package:frontend/models/survey_modules/questionnaires/who5.dart';

class QuestionnaireData {
  Eq5d eq5d;
  Who5 who5;

  bool get isComplete => eq5d.isComplete && who5.isComplete;

  QuestionnaireData({required this.eq5d, required this.who5});

  Map<String, dynamic> toJson() => {
    'eq5d_responses': eq5d.toJson(),
    'who5_responses': who5.toJson(),
  };
}
