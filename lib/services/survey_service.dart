import 'dart:convert';
import 'dart:io';

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

/// Verwaltet den Lebenszyklus einer Umfrage.
///
/// Der Service übernimmt das Erstellen, Zwischenspeichern, Wiederherstellen
/// und Übertragen von Umfragen sowie das Speichern der einzelnen
/// Umfragemodule während der Bearbeitung.
class SurveyService {
  Survey? currentSurvey;
  static const String storageKey = 'current_survey';

  /// Erstellt eine neue Umfrage und legt sie im lokalen Zwischenspeicher ab.
  Future<void> startSurvey() async {
    currentSurvey = Survey();
    await cacheSurvey();
  }

  /// Verwirft die aktuelle Umfrage und entfernt sie aus dem lokalen Zwischenspeicher.
  Future<void> cancelSurvey() async {
    try {
      currentSurvey = null;

      clearCache();
    } catch (e) {
      throw Exception("CANCEL_SURVEY_ERROR: $e");
    }
  }

  /// Überträgt die abgeschlossene Umfrage an das Backend.
  ///
  /// Nach erfolgreicher Übertragung wird die lokale Kopie der Umfrage entfernt.
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

  /// Lädt eine lokal zwischengespeicherte laufende Umfrage.
  ///
  /// Wird beim Appstart aufgerufen, um alle Felder mit den entsprechenden Werten auszufüllen.
  Future<void> loadCachedSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(storageKey);

    if (json == null) return;

    currentSurvey = Survey.fromJson(jsonDecode(json));
  }

  /// Speichert die personenbezogenen Angaben der aktuellen Umfrage.
  Future<void> savePersonalData(PersonalData personalData) async {
    if (currentSurvey == null) {
      throw Exception("NO_ACTIVE_SURVEY");
    }

    currentSurvey!.personalData = personalData;

    await cacheSurvey();
  }

  /// Speichert die Kontextinformationen der aktuellen Umfrage.
  Future<void> saveContextData(ContextData contextData) async {
    if (currentSurvey == null) {
      throw Exception("NO_ACTIVE_SURVEY");
    }

    currentSurvey!.contextData = contextData;
    await cacheSurvey();
  }

  /// Speichert die Ergebnisse des CCSM-Hörtests.
  Future<void> saveCcsm(CcsmAudioTest ccsm) async {
    currentSurvey!.audioTestData.ccsm = ccsm;
    await cacheSurvey();
  }

  /// Speichert die Antworten des EQ-5D-5L-Fragebogens.
  Future<void> saveEq5d(Eq5d eq5d) async {
    currentSurvey!.questionnaireData.eq5d = eq5d;
    await cacheSurvey();
  }

  /// Speichert die Antworten des WHO-5-Fragebogens.
  Future<void> saveWho5(Who5 who5) async {
    currentSurvey!.questionnaireData.who5 = who5;
    await cacheSurvey();
  }

  /// Legt die aktuelle Umfrage als JSON im lokalen Zwischenspeicher ab.
  Future<void> cacheSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(currentSurvey));
  }

  /// Entfernt die lokal zwischengespeicherte Umfrage.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  /// Lädt eine Übersicht aller bereits abgeschlossenen Umfragen
  /// des aktuellen Teilnehmers aus dem Backend.
  Future<List<SurveyOverview>> getPreviousSurveys() async {
    final participantId = await sessionService.getCurrentParticipantId();

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/surveys"),
        headers: {"X-Participant-Id": participantId!},
      );

      if (response.statusCode != 200) {
        throw Exception("SURVEY_REQUEST_FAILED");
      }

      final List<dynamic> json = jsonDecode(response.body);

      final surveys = json.map((e) {
        return SurveyOverview.fromJson(e);
      }).toList();

      return surveys;
    } on SocketException {
      throw Exception("SERVER_UNREACHABLE");
    }
  }

  /// Prüft, ob das angegebene Alter den definierten Eingaberegeln entspricht.
  /// Bei ungültigen Eingaben wird eine passende Fehlermeldung zurückgegeben.
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
