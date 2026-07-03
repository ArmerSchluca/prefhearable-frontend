import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/validation.dart';

/// Service zum Anlegen eines Participants, sobald ein Nutzer "Jetzt loslegen!" geklickt hat.
/// Dabei wird eine UUID vom Server erzeugt und an den Client geschickt.
/// SharedPreferences dient dabei als Local Storage, um die UUID als Identifikator zu speichern.
/// Damit wird sich nach dme Schließen der App solange wieder automatisch angemeldet,
/// bis sich explizitüber die UI abgemeldet wird.
class SessionService {
  final String baseUrl = _getBaseUrl();

  static const String _storageKey = 'participant_uuid';

  /// Fordert bei der ersten Nutzung der App beim Server die Erzeugung einer UUID an,
  /// die anschließend im Local Storage gespeichert wird
  Future<String> registerParticipant() async {
    final response = await http.post(Uri.parse('$baseUrl/participants'));

    if (response.statusCode != 201) {
      throw Exception('Could not create participant');
    }

    final data = jsonDecode(response.body);
    final participantId = data['participantId'] as String;

    await _saveToLocal(participantId);

    return participantId;
  }

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

      await _saveToLocal(participantId);

      return participantId;
    } on SocketException {
      throw Exception("SERVER_UNREACHABLE");
    }
  }

  Future<String?> getCurrentParticipantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageKey);
  }

  Future<void> logoutParticipant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> _saveToLocal(String participantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, participantId);
  }

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    }
    // Windows / macOS / Linux / iOS / Browser
    return "http://localhost:3000";
  }
}
