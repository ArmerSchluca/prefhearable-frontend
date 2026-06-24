import 'package:flutter/material.dart';
import 'package:frontend/view/home_view.dart';
import 'package:frontend/view/uuid_login_view.dart';
import 'package:frontend/service/session_service.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({super.key});

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  final SessionService _participantService = SessionService();
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Prefhearable", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INTRO TEXT
            Text(
              "Prefhearable...",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(height: 10.0),
            Text(
              "ist eine App zur Erforschung individueller Hörpräferenzen. Wir untersuchen, welchen Einfluss Gesundheit und Umgebung auf das Hörverhalten haben. Mit Ihrer Teilnahme unterstützen Sie den Aufbau eines Datensatzes für die zukünftige Forschung und personalisierte Hörversorgung.",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20),
            Text(
              "Vielen Dank für Ihre Teilnahme!",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 40),

            // CONSENT CHECKBOX
            Row(
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    activeColor: Colors.green,
                    value: _consentGiven,
                    onChanged: (value) {
                      setState(() {
                        _consentGiven = value ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    "Ich bin einverstanden, dass meine Daten pseudonymisiert gespeichert und zu Forschungszwecken verarbeitet werden.",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // "Loslegen" BUTTON
            SizedBox(
              width: double.infinity,
              height: 80,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey.shade700;
                    }
                    return Colors.blue;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey.shade300;
                    }
                    return Colors.white;
                  }),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                onPressed: _consentGiven
                    ? () async {
                        try {
                          final id = await _participantService
                              .registerParticipant();

                          debugPrint("NEW PARTICIPANT: $id");

                          if (!mounted) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          );
                        } catch (e) {
                          debugPrint("REGISTER ERROR: $e");
                        }
                      }
                    : null,
                child: const Text(
                  'Jetzt loslegen!',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(child: Text("oder", style: TextStyle(fontSize: 16.0))),
            SizedBox(height: 30),
            Center(
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                child: Text(
                  'mit UUID anmelden',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
