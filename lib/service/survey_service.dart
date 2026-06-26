class SurveyService {
  Future createSurvey() async {}

  Future cancelActiveSurvey() async {}

  Future deletePreviousSurvey(String surveyId) async {}

  Future submitSurvey() async {}

  Future<void> _cacheSurveyInputs(String participantId) async {
    // Falls App abstürzt, man pausieren will oder
  }
}
