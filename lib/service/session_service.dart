import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/validation.dart';

/// Service zum Anlegen eines Participants, sobald ein Nutzer "Jetzt loslegen!" geklickt hat.
/// Dabei wird eine UUID vom Server erzeugt und an den Client geschickt.
/// SharedPreferences dient dabei als Local Storage, um die UUID als Identifikator zu speichern.
/// Damit wird sich nach dme Schließen der App solange wieder automatisch angemeldet,
/// bis sich explizitüber die UI abgemeldet wird.
class SessionService {
  final String baseUrl = "http://localhost:3000";

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
    // Format lokal validieren
    final isValidFormat = UuidValidation.isValidUUID(fromString: participantId);

    if (!isValidFormat) {
      throw Exception("Invalid UUID format");
    }

    // Im Backend prüfen, ob die UUID im System ist
    final response = await http.get(
      Uri.parse('$baseUrl/participants/me'),
      headers: {'X-Participant-Id': participantId},
    );

    if (response.statusCode != 200) {
      throw Exception("Participant does not exist");
    }

    // lokal speichern
    await _saveToLocal(participantId);

    return participantId;
  }

  Future<String?> getCurrentParticipantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageKey);
  }

  Future<void> logoutParticipant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// PRIVATE STORAGE HELPER
  Future<void> _saveToLocal(String participantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, participantId);
  }

  Future<bool> checkServerHealth() async {
    try {
      log('REQUEST → $baseUrl/health');
      
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      log('STATUS: ${response.statusCode}');
      log('BODY: ${response.body}');

      return response.statusCode == 200;
    } catch (e, stack) {
      log('❌ SERVER ERROR: $e');
      log('$stack');
      return false;
    }
  }
}
