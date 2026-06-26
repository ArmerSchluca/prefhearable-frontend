import 'package:flutter/material.dart';
import 'package:frontend/service/survey_service.dart';
import 'package:frontend/shared/app_dialogs.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/shared/custom_appbar.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/view/home_view.dart';
import 'package:frontend/view/survey_data_views/audiotest_view.dart';
import 'package:frontend/view/survey_data_views/context_data_view.dart';
import 'package:frontend/view/survey_data_views/person_data_view.dart';
import 'package:frontend/view/survey_data_views/questionnaires_view.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    final SurveyService surveyService = SurveyService();

    return AppLayout(
      footer: AppFooter(
        actions: [
          // LOGOUT BUTTON
          TextButton(
            child: Text(
              "Umfrage abbrechen",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: Colors.red,
              ),
            ),
            onPressed: () async {
              final result = await AppDialog.showSelection(
                context,
                Text("Umfrage wirklich abbrechen?"),
                Text("Jegliche Eingaben gehen unwiderruflich verloren!"),
              );

              if (result == true) {
                await surveyService.cancelActiveSurvey();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeView()),
                  (route) => false,
                );
              }
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
                const Text("Infos zur Umfrage"),
                const Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                ),
              );
            },
          ),
        ],
      ),
      appBar: CustomAppBar(
        title: "Umfrage",
        color: Colors.blueAccent,
        nav: true,
      ),
      children: [
        SectionCard(
          title: "Personal Data",
          icon: Icon(Icons.person, color: Colors.orange, size: 40),
          status: SectionStatus.open,
          destination: PersonalDataView(),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Contextual Data",
          icon: Icon(Icons.public, color: Colors.green, size: 40),
          status: SectionStatus.open,
          destination: ContextDataView(),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Audio Tests",
          icon: Icon(Icons.headphones, color: Colors.pinkAccent, size: 40),
          status: SectionStatus.open,
          destination: AudioTestView(),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Questionnaires",
          icon: Icon(
            Icons.assignment,
            color: Colors.deepPurpleAccent,
            size: 40,
          ),
          status: SectionStatus.open,
          destination: QuestionnairesView(),
        ),

        SizedBox(height: 12),
      ],
    );
  }
}

class SectionCard extends Card {
  final String title;
  final Icon icon;
  final SectionStatus status;
  final Widget destination;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.status,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Column(
            mainAxisSize: .min,
            children: <Widget>[
              ListTile(
                leading: icon,
                title: Text(title),
                subtitle: Text(status.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SectionStatus { open, partial, completed }
