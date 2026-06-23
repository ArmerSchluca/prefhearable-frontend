import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Service zum Anlegen eines Participants, sobald ein Nutzer "Jetzt loslegen!" geklickt hat.
/// Dabei wird eine UUID vom Server erzeugt und an den Client geschickt.
/// SharedPreferences dient dabei als Local Storage, um die UUID als Identifikator zu speichern.
/// Damit wird sich nach dme Schließen der App solange wieder automatisch angemeldet,
/// bis sich explizitüber die UI abgemeldet wird.
class ParticipantService {
  final baseUrl = "http://localhost:3000";

  Future<String> registerParticipant() async {
    final response = await http.post(Uri.parse('$baseUrl/participants'));

    if (response.statusCode != 201) {
      throw Exception('Could not create participant');
    }

    final data = jsonDecode(response.body);

    final participantId = data['participantId'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('participant_uuid', participantId);

    return participantId;
  }

  Future<String?> getParticipantIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('participant_uuid');
  }

  Future<void> logoutParticipant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('participant_uuid');
  }
}
