import 'dart:convert';
import 'dart:io';
import 'package:frontend/utils/base_url.dart';
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
  /// Anmeldung wird die UUID lokal gespeichert.
  Future<String> loginWithUuid(String participantId) async {
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

      await _cacheId(participantId);

      return participantId;
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
  }

  /// Speichert die Teilnehmer-ID lokal auf dem Gerät,
  /// um sich beim Appstart (bis zur Abmeldung) automatisch anzumelden.
  Future<void> _cacheId(String participantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, participantId);
  }
}
