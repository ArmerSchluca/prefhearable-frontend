import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:frontend/models/previous_surveys.dart';
import 'package:frontend/models/survey_modules/audio_tests/ccsm.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';
import 'package:frontend/models/survey.dart';
import 'package:frontend/models/survey_modules/questionnaires/eq5d.dart';
import 'package:frontend/models/survey_modules/questionnaires/who5.dart';
import 'package:frontend/utils/base_url.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SurveyService {
  Survey? currentSurvey;
  String storageKey = 'current_survey';

  Future<void> startSurvey() async {
    currentSurvey = Survey();
    debugPrint("SURVEY_CREATED");
    await cacheSurvey();
  }

  Future<void> cancelSurvey() async {
    try {
      currentSurvey = null;

      clearCache();
    } catch (e) {
      throw Exception("CANCEL_SURVEY_ERROR: $e");
    }
  }

  Future<void> submitSurvey() async {
    final participantId = await sessionService.getCurrentParticipantId();

    if (participantId == null) {
      throw Exception("NO_PARTICIPANT");
    }

    currentSurvey!.finishedAt = DateTime.now();

    final response = await http.post(
      Uri.parse("$baseUrl/surveys"),
      headers: {
        "Content-Type": "application/json",
        "X-Participant-Id": participantId,
      },
      body: jsonEncode(currentSurvey),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        "Survey konnte nicht übertragen werden (${response.statusCode})",
      );
    }

    currentSurvey = null;
    clearCache();
  }

  Future<void> loadCachedSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(storageKey);

    debugPrint("Cached survey: $json");

    if (json == null) return;

    currentSurvey = Survey.fromJson(jsonDecode(json));
    debugPrint("SURVEY_LOADED");
  }

  Future<void> savePersonalData(PersonalData personalData) async {
    if (currentSurvey == null) {
      throw Exception("NO_ACTIVE_SURVEY");
    }

    currentSurvey!.personalData = personalData;

    await cacheSurvey();
  }

  Future<void> saveContextData(ContextData contextData) async {
    if (currentSurvey == null) {
      throw Exception("NO_ACTIVE_SURVEY");
    }

    currentSurvey!.contextData = contextData;
    await cacheSurvey();
  }

  Future<void> saveCcsm(CcsmAudioTest ccsm) async {
    currentSurvey!.audioTestData.ccsm = ccsm;
    await cacheSurvey();
  }

  Future<void> saveEq5d(Eq5d eq5d) async {
    currentSurvey!.questionnaireData.eq5d = eq5d;
    await cacheSurvey();
  }

  Future<void> saveWho5(Who5 who5) async {
    currentSurvey!.questionnaireData.who5 = who5;
    await cacheSurvey();
  }

  Future<void> cacheSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(currentSurvey));
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  Future<List<SurveyOverview>> getPreviousSurveys() async {
    try {
      debugPrint("getPreviousSurveys()");

      final participantId = await sessionService.getCurrentParticipantId();

      final response = await http.get(
        Uri.parse("$baseUrl/surveys"),
        headers: {"X-Participant-Id": participantId!},
      );

      debugPrint(response.body);

      final List<dynamic> json = jsonDecode(response.body);

      debugPrint("JSON dekodiert");

      final surveys = json.map((e) {
        debugPrint("Mappe: $e");
        return SurveyOverview.fromJson(e);
      }).toList();

      debugPrint("Surveys geladen: ${surveys.length}");

      return surveys;
    } catch (e, stackTrace) {
      debugPrint("FEHLER: $e");
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  String? validateAge(int? age) {
    if (age == null) {
      return "Bitte Alter angeben.";
    }

    if (age <= 0) {
      return "Bitte eine positive Ganzzahl eingeben.";
    }

    if (age >= 120 || age <= 5) {
      return "Bitte ein realistisches Alter angeben.";
    }

    return null;
  }
}
