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

  /// Prüft, ob bereits eine gültige Teilnehmersitzung vorhanden ist.
  ///
  /// Bei erfolgreicher Anmeldung wird eine eventuell zwischengespeicherte
  /// Umfrage wiederhergestellt und zur Startseite navigiert. Andernfalls
  /// erfolgt die Weiterleitung zur Registrierungsansicht.
  Future<void> _checkSession() async {
    final id = await sessionService.getCurrentParticipantId();

    if (!mounted) return;

    if (id != null) {
      try {
        await sessionService.loginWithUuid(id);
        await surveyService.loadCachedSurvey();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );

        return;
      } catch (e, stackTrace) {
        debugPrint("Launch failed: $e");
        debugPrintStack(stackTrace: stackTrace);

        await sessionService.logoutParticipant();
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LaunchView()),
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
