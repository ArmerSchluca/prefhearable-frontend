class SurveyService {
  Future createSurvey() async {}

  Future cancelActiveSurvey() async {}

  Future deletePreviousSurvey(id) async {}

  Future submitSurvey() async {}

  Future<void> _cacheSurveyInputs(String participantId) async {
    // Falls App abstürzt, man pausieren will oder
  }
}
