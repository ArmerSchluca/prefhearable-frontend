import 'package:flutter/material.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/launch_view.dart';
import 'package:frontend/utils/base_url.dart';
import 'package:http/http.dart' as http;

/// Initialer Einstiegspunkt der Anwendung nach dem Start.
///
/// Der Helper prüft die Erreichbarkeit des Backends sowie eine eventuell
/// vorhandene Session und leitet anschließend zur passenden Ansicht weiter.
class LaunchHandler extends StatefulWidget {
  const LaunchHandler({super.key});

  @override
  State<LaunchHandler> createState() => _LaunchHandlerState();
}

class _LaunchHandlerState extends State<LaunchHandler> {
  /// Führt die Initialisierung der Anwendung aus.
  /// Dabei werden die Serververbindung sowie eine bestehende Sitzung geprüft.
  @override
  void initState() {
    super.initState();
    _checkServerConnection();
    _checkSession();
  }

  /// Prüft beim Appstart, ob eine gespeicherte Teilnehmersitzung vorhanden ist.
  ///
  /// Ist eine Session vorhanden, wird diese nach Möglichkeit über das Backend
  /// validiert. Bei fehlender Serververbindung wird die lokale Sitzung
  /// weiterverwendet, sodass zwischengespeicherte Umfragen auch offline
  /// fortgesetzt werden können.
  ///
  /// Existiert keine Session oder ist die gespeicherte UUID ungültig, erfolgt
  /// die Weiterleitung zur Registrierungsansicht (LiveView).
  Future<void> _checkSession() async {
    // Lokal gespeicherte Teilnehmer-ID laden
    final id = await sessionService.getCurrentParticipantId();

    if (!mounted) return;

    // Keine aktive Sitzung vorhanden -> LaunchView anzeigen
    if (id == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LaunchView()),
      );
      return;
    }

    try {
      // UUID serverseitig validieren
      participant = await sessionService.authenticateParticipant(id);
    } catch (e) {
      // Offline-Modus: lokale Sitzung weiterhin verwenden
      if (e.toString().contains("SERVER_UNREACHABLE")) {
        debugPrint("Offline-Modus");
        // Alle anderen werfbaren Exceptions bedeuten, dass die gespeicherte UUID
        // ungültig oder nicht mehr vorhanden ist.
      } else {
        await sessionService.logoutParticipant();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LaunchView()),
        );

        return;
      }
    }

    // Eventuell begonnene Umfrage aus dem lokalen Speicher holen
    await surveyService.loadCachedSurvey();

    if (surveyService.currentSurvey != null) {
      // Personendaten laden -> lokal gespeicherte Personendaten haben Vorrang
      participant.personalData = surveyService.currentSurvey!.personalData
          .copy();
    }

    if (!mounted) return;

    // Zur Startseite navigieren
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  /// Zeigt während der Initialisierung einen Ladeindikator an.
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  /// Prüft, ob das Backend erreichbar ist.
  ///
  /// Die Verbindung wird über den Endpunkt /health des Backends validiert.
  Future<void> _checkServerConnection() async {
    final response = await http.get(Uri.parse('$baseUrl/health'));

    if (response.statusCode != 200) {
      throw Exception("SERVER_CONNECTION_FAILED");
    }

    debugPrint('SERVER_CONNECTION_SUCCESSFUL');
  }
}
