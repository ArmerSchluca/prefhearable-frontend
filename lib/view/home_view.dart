import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/shared/app_dialogs.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/util/session.dart';
import 'package:frontend/view/launch_view.dart';
import 'package:frontend/view/previous_surveys_view.dart';
import 'package:frontend/view/survey_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      footer: AppFooter(
        actions: [
          // LOGOUT BUTTON
          TextButton.icon(
            icon: RotatedBox(
              quarterTurns: 2,
              child: Icon(Icons.logout, size: 20, color: Colors.red),
            ),
            label: Text(
              "Abmelden",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            onPressed: () async {
              final uuid = await session.getCurrentParticipantId();

              if (uuid == null) return;

              final confirmed = await AppDialog.showUuidConfirmation(
                context,
                uuid,
                "Wirklich abmelden? ",
                "Laufende Umfragen werden abgebrochen! Wenn Sie künftig auf Ihre bisherigen Umfragen zugreifen können möchten, sichern Sie vorher Ihre UUID zur Anmeldung!"
                    " Bitte geben Sie Ihren Zugangscode zur Bestätigung ein.",
              );

              if (!confirmed) return;

              await session.logoutParticipant();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Abmeldung erfolgreich!"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LaunchView()),
                (route) => false,
              );
            },
          ),

          // INFO BUTTON
          TextButton.icon(
            icon: Icon(Icons.info, size: 20, color: Colors.blueGrey),
            label: Text(
              "Info",
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
            onPressed: () {
              AppDialog.showInfo(
                context,
                const Text("Titel"),
                const Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                ),
              );
            },
          ),
        ],
      ),

      // INHALT DER SEITE
      children: [
        SizedBox(height: 20),
        // NEUE UMFRAGEN BUTTOM
        SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            style: FilledButton.styleFrom(
              elevation: 3,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0), // eckig
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
                Icon(Icons.play_arrow, size: 24),
                SizedBox(width: 8),
                Text("Neue Umfrage starten", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),

        SizedBox(height: 50),

        // VORHERIGE UMFRAGEN BUTTON
        SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            style: FilledButton.styleFrom(
              elevation: 3,
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // eckig
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreviousSurveysView(),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 24),
                SizedBox(width: 8),
                AutoSizeText(
                  "Vorherige Umfragen",
                  style: TextStyle(fontSize: 20),
                  minFontSize: 18,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 50),

        // GRAUER KASTEN MIT UUID/Zugangscode
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Ihr Zugangscode:",
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),

                const SizedBox(height: 15),

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
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                const Text(
                  "Sichern Sie Ihren Zugangscode, um "
                  "geräteübergreifend auf Ihre Daten zuzugreifen.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
