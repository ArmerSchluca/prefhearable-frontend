import 'package:frontend/models/personal_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyService {
  Future createSurvey() async {}

  Future cancelActiveSurvey() async {}

  Future submitSurvey() async {}

  Future savePersonalData(PersonalData personalData) async {}

/*
  Future<void> _cacheSurvey() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "activeSurvey",
      jsonEncode(_currentSurvey!.toJson()),
    );
  }
  */
}
