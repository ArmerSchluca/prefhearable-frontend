import 'package:flutter/material.dart';
import 'package:frontend/models/previous_surveys.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:intl/intl.dart';

class PreviousSurveysView extends StatelessWidget {
  const PreviousSurveysView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      footer: AppFooter(
        actions: [
          Spacer(),
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
                Text("Infos zur Umfrage"),
                Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                ),
              );
            },
          ),
        ],
      ),
      appBar: CustomAppBar(
        title: "Vorherige Umfragen",
        color: Colors.teal,
        nav: true,
      ),
      children: [
        // Ruft die abgeschlossenen Umfragen vom Backend ab und stellt abhängig
        // vom Ladezustand entweder einen Ladeindikator, eine Fehlermeldung,
        // einen Hinweis auf fehlende Daten oder, sobald die Daten da sind, die Ergebnisliste dar.
        // Ruft die abgeschlossenen Umfragen vom Backend ab und stellt abhängig
        // vom Ladezustand entweder einen Ladeindikator, eine Fehlermeldung,
        // einen Hinweis auf fehlende Daten oder die Ergebnisliste dar.
        FutureBuilder<List<SurveyOverview>>(
          future: surveyService.getPreviousSurveys(),
          builder: (context, snapshot) {
            // Daten werden noch geladen
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }

            // Fehler beim Laden der Umfragen
            if (snapshot.hasError) {
              final error = snapshot.error.toString();

              if (error.contains("SERVER_UNREACHABLE")) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Der Server ist derzeit nicht erreichbar.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Vorherige Umfragen können momentan nicht geladen werden.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: Text(
                  "Beim Laden der Umfragen ist ein Fehler aufgetreten.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Anfrage erfolgreich, aber noch keine abgeschlossenen Umfragen vorhanden
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Es wurden noch keine Umfragen abgeschlossen.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final surveys = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              // AppLayout übernimmt Scrollable. Sonst kann man im Scrollpane scrollen
              physics: NeverScrollableScrollPhysics(),
              itemCount: surveys.length,
              itemBuilder: (context, index) {
                return _buildSurveyCard(surveys[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

Widget _buildSurveyCard(SurveyOverview survey) {
  return Card(
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.teal.shade50,
        foregroundColor: Colors.teal,
        child: const Icon(Icons.assignment),
      ),

      title: Text("Umfrage v${survey.surveyVersion}"),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Text(DateFormat("dd.MM.yyyy HH:mm").format(survey.finishedAt)),
          Text(
            "Dauer: ${survey.finishedAt.difference(survey.startedAt).inMinutes} min",
          ),
        ],
      ),

      trailing: Icon(Icons.chevron_right),

      onTap: () {
        // später Detailansicht
      },
    ),
  );
}
