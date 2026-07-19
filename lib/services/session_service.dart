import 'dart:convert';
import 'dart:io';
import 'package:frontend/models/particpant.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';
import 'package:frontend/utils/base_url.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/validation.dart';

/// Verwaltet die Sitzung eines Teilnehmers.
///
/// Der Service übernimmt die Registrierung und Anmeldung eines Teilnehmers,
/// speichert dessen UUID lokal und stellt sie während der Laufzeit der
/// Anwendung zur Verfügung.
class SessionService {
  static final String storageKey = 'participant_uuid';

  /// Registriert einen neuen Teilnehmer im Backend.
  ///
  /// Die vom Backend erzeugte UUID wird lokal gespeichert und anschließend
  /// zurückgegeben.
  Future<String> registerParticipant() async {
    final response = await http.post(Uri.parse('$baseUrl/participants'));

    if (response.statusCode != 201) {
      throw Exception('Could not create participant');
    }

    final data = jsonDecode(response.body);
    final participantId = data['participantId'] as String;

    await _cacheId(participantId);

    return participantId;
  }

  /// Meldet einen Teilnehmer anhand seiner UUID an.
  ///
  /// Vor der Anmeldung wird das Format der UUID geprüft. Anschließend wird
  /// im Backend validiert, ob der Teilnehmer existiert. Bei erfolgreicher
  /// Anmeldung wird der Participant mit UUID und Personendaten lokal gespeichert.
  Future<Participant> authenticateParticipant(String participantId) async {
    if (!UuidValidation.isValidUUID(fromString: participantId)) {
      throw Exception("INVALID_UUID_FORMAT");
    }

    // Im Backend prüfen, ob die UUID existiert
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/participants/me'),
        headers: {'X-Participant-Id': participantId},
      );

      if (response.statusCode != 200) {
        throw Exception("PARTICIPANT_NOT_FOUND");
      }

      final participant = Participant.fromJson(jsonDecode(response.body));

      await _cacheId(participantId);

      return participant;
    } on SocketException {
      throw Exception("SERVER_UNREACHABLE");
    }
  }

  /// Gibt die lokal gespeicherte Teilnehmer-ID zurück.
  ///
  /// Falls keine Sitzung vorhanden ist, wird `null` zurückgegeben.
  Future<String?> getCurrentParticipantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(storageKey);
  }

  /// Aktualisiert die im Backend gespeicherten Personendaten
  /// des angemeldeten Teilnehmers.
  ///
  /// Wird nach erfolgreichem Abschluss einer Umfrage aufgerufen,
  /// damit die zuletzt eingegebenen Personendaten für zukünftige
  /// Umfragen wiederverwendet werden können.
  Future<void> updatePersonalDataOnParticipant(
    PersonalData personalData,
  ) async {
    final participantId = await getCurrentParticipantId();

    final response = await http.put(
      Uri.parse('$baseUrl/participants/me/personal-data'),
      headers: {
        'Content-Type': 'application/json',
        'X-Participant-Id': participantId!,
      },
      body: jsonEncode(personalData),
    );

    if (response.statusCode != 204) {
      throw Exception("COULD_NOT_UPDATE_PERSONAL_DATA");
    }
  }

  /// Meldet den aktuellen Teilnehmer ab.
  ///
  /// Entfernt die zwischengespeicherte Teilnehmer-ID aus dem SharedStorage
  /// und ggf. eine laufende Umfrage.
  Future<void> logoutParticipant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);

    if (surveyService.currentSurvey != null) {
      surveyService.cancelSurvey();
    }

    // Personendaten aus Local Storage clearen
    participant.personalData = PersonalData();
  }

  /// Speichert die Teilnehmer-ID lokal auf dem Gerät,
  /// um sich beim Appstart (bis zur Abmeldung) automatisch anzumelden.
  Future<void> _cacheId(String participantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, participantId);
  }
}
