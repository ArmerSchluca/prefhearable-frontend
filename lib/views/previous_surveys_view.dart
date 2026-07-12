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
        FutureBuilder<List<SurveyOverview>>(
          future: surveyService.getPreviousSurveys(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                final survey = surveys[index];

                return _buildSurveyCard(survey);
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
