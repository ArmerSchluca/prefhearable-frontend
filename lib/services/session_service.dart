import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/validation.dart';

class SessionService {
  final String baseUrl = _getBaseUrl();
  final String storageKey = 'participant_uuid';

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
    return prefs.getString(storageKey);
  }

  Future<void> logoutParticipant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  Future<void> _saveToLocal(String participantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, participantId);
  }

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    }
    // Windows / macOS / Linux / iOS / Browser
    return "http://localhost:3000";
  }
}
