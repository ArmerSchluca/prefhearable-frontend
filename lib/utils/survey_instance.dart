import 'package:frontend/services/survey_service.dart';

/// SurveyService-Instanz, um nicht immer eine neue Instanz vom Service erzeugen zu müssen (Single Point Of Truth)
final SurveyService survey = SurveyService();