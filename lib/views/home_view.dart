import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/session_service.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:frontend/views/launch_view.dart';
import 'package:frontend/views/previous_surveys_view.dart';
import 'package:frontend/views/survey_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

              if (!context.mounted) return;
              final confirmed = await AppDialog.showUuidConfirmation(
                context,
                uuid,
                "Wirklich abmelden? ",
                "Laufende Umfragen werden abgebrochen! Wenn Sie künftig auf Ihre bisherigen Umfragen zugreifen können möchten, "
                    " sichern Sie vorher Ihren Zugangscode zur Anmeldung!"
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
                MaterialPageRoute(builder: (_) => LaunchView()),
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
                Text("Titel"),
                Text(
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
        // NEUE UMFRAGEN BUTTON
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

            onPressed: () async {
              if (survey.currentSurvey == null) {
                await survey.startSurvey();
                setState(() {});
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Umfrage gestartet!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                await survey.loadCachedSurvey();
                setState(() {});
              }

              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SurveyView()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  survey.currentSurvey != null ? Icons.pause : Icons.play_arrow,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  survey.currentSurvey != null
                      ? "Umfrage fortsetzen"
                      : "Neue Umfrage starten",
                  style: TextStyle(fontSize: 20),
                ),
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
                MaterialPageRoute(builder: (context) => PreviousSurveysView()),
              );
            },
            child: Row(
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
            padding: EdgeInsets.all(30),
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

                FutureBuilder<String?>(
                  future: SessionService().getCurrentParticipantId(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Lade...");
                    }

                    final id = snapshot.data;

                    if (id == null) {
                      return Text("kein Zugangscode vorhanden");
                    }

                    return SelectableText(
                      id,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                SizedBox(height: 15),
                Text(
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
