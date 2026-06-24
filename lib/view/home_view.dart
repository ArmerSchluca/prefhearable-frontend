import 'package:flutter/material.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/shared/alert_dialog.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/view/launch_view.dart';
import 'package:frontend/view/survey_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionService _sessionService = SessionService();

    return AppLayout(
      children: [
        // NEUE UMFRAGEN BUTTOM
        SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.blue),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // eckig
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SurveyView()),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, size: 30),
                SizedBox(width: 8),
                Text("Neue Umfrage starten", style: TextStyle(fontSize: 24.0)),
              ],
            ),
          ),
        ),

        SizedBox(height: 30),

        // VORHERIGE UMFRAGEN BUTTON
        SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.teal),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // eckig
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SurveyView()),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 30),
                SizedBox(width: 8),
                Text("Vorherige Umfragen", style: TextStyle(fontSize: 24.0)),
              ],
            ),
          ),
        ),

        SizedBox(height: 30),

        // GRAUER KASTEN MIT UUID
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFFD3D3D3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ihr Zugangscode:",
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),

              SizedBox(height: 15),

              // Hier wird die UUID des eingeloggten Users aus dem Future extrahiert, um als String angezeigt werden zu können
              FutureBuilder<String?>(
                future: SessionService().getCurrentParticipantId(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Lade...");
                  }

                  final id = snapshot.data;

                  if (id == null) {
                    return const Text("kein Zugangscode vorhanden");
                  }

                  return SelectableText(
                    id,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              SizedBox(height: 15),

              Text(
                "Sichern Sie Ihren Zugangscode, um bei Bedarf "
                "geräteübergreifend auf Ihre Daten zuzugreifen.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),

        // LOGOUT BUTTON
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              final result = await AppDialog.showSelection(
                context,
                const Text("Abmelden"),
                const Text("Möchtest du dich wirklich abmelden?"),
              );

              if (result == true) {
                await _sessionService.logoutParticipant();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LaunchView()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Abmelden", style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }
}
