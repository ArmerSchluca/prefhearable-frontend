import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:frontend/models/personal_data.dart';
import 'package:frontend/models/survey.dart';
import 'package:frontend/utils/base_url.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SurveyService {
  Survey? currentSurvey;
  String storageKey = 'current_survey';

  Future<void> createSurvey() async {
    currentSurvey = Survey();
    debugPrint("SURVEY_CREATED");
    //await _cacheSurvey(currentSurvey!);
  }

  Future<void> cancelSurvey() async {}

  Future<void> submitSurvey() async {
    final participantId = await session.getCurrentParticipantId();

    if (participantId == null) {
      throw Exception("NO_PARTICIPANT");
    }

    await http.post(
      Uri.parse("$baseUrl/surveys"),
      headers: {
        "Content-Type": "application/json",
        "X-Participant-Id": participantId,
      },
      body: jsonEncode(currentSurvey!.toJson()),
    );
  }

  Future<void> loadCachedSurvey() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(storageKey);

    if (json == null) return;

    //currentSurvey = Survey.fromJson(jsonDecode(json));
  }

  Future<void> savePersonalData(PersonalData personalData) async {
    if (currentSurvey == null) {
      throw Exception("NO_ACTIVE_SURVEY");
    }

    currentSurvey!.personalData = personalData;

    // await _cacheSurvey(currentSurvey!);
  }

  Future<void> saveContextData() async {}

  Future<void> saveAudioTest() async {}

  Future<void> saveQuestionnaires() async {}

  Future<void> _cacheSurvey(Survey survey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(survey.toJson()));
  }
}
