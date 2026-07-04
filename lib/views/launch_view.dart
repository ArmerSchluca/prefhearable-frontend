import 'package:flutter/material.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/session.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/login_view.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({super.key});

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  bool consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      children: [
        Text(
          "Prefhearable...",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 10),
        Text(
          "ist eine App zur Erforschung individueller Hörpräferenzen. Wir untersuchen, welchen Einfluss Gesundheit und Umgebung auf das Hörverhalten haben. Mit Ihrer Teilnahme unterstützen Sie den Aufbau eines Datensatzes für die zukünftige Forschung und personalisierte Hörversorgung.",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        Text("Vielen Dank für Ihre Teilnahme!", style: TextStyle(fontSize: 18)),
        SizedBox(height: 40),

        // CONSENT CHECKBOX
        Row(
          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                activeColor: Colors.green,
                value: consentGiven,
                onChanged: (value) {
                  setState(() {
                    consentGiven = value ?? false;
                  });
                },
              ),
            ),
            Expanded(
              child: Text(
                "Ich bin einverstanden, dass meine Daten pseudonymisiert gespeichert und zu Forschungszwecken verarbeitet werden.",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        // "Loslegen" BUTTON
        SizedBox(
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey;
                }
                return Colors.blue;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade300;
                }
                return Colors.white;
              }),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            onPressed: consentGiven
                ? () async {
                    try {
                      final id = await session.registerParticipant();
                      debugPrint("REGISTERED: $id");

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeView()),
                        );
                      } else {
                        return;
                      }
                    } catch (e) {
                      AppDialog.showServerError(context);
                      debugPrint("REGISTER ERROR: $e");
                    }
                  }
                : null,
            child: Text('Jetzt loslegen!', style: TextStyle(fontSize: 20)),
          ),
        ),
        SizedBox(height: 30),
        Center(child: Text("oder", style: TextStyle(fontSize: 16))),
        SizedBox(height: 30),
        Center(
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
            child: Text(
              'mit Zugangscode anmelden',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
