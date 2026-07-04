import 'package:flutter/material.dart';
import 'package:frontend/models/enum_extensions.dart';
import 'package:frontend/services/survey_service.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/survey_modules/audiotest_view.dart';
import 'package:frontend/views/survey_modules/context_data_view.dart';
import 'package:frontend/views/survey_modules/personal_data_view.dart';
import 'package:frontend/views/survey_modules/questionnaires_view.dart';

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
          title: "Personendaten",
          icon: Icon(Icons.person, color: Colors.orange, size: 40),
          status: SectionStatus.incomplete,
          destination: PersonalDataView(),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Kontextdaten",
          icon: Icon(Icons.public, color: Colors.green, size: 40),
          status: SectionStatus.complete,
          destination: ContextDataView(),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Hörtests",
          icon: Icon(Icons.headphones, color: Colors.pinkAccent, size: 40),
          status: SectionStatus.complete,
          destination: AudioTestView(),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Umfragebögen",
          icon: Icon(
            Icons.assignment,
            color: Colors.deepPurpleAccent,
            size: 40,
          ),
          status: SectionStatus.complete,
          destination: QuestionnairesView(),
        ),

        SizedBox(height: 50),

        Center(
          child: FilledButton(
            style: FilledButton.styleFrom(
              elevation: 3,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Umfrage abschließen",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Icon(Icons.send, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
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
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 15),
          child: ListTile(
            leading: icon,
            title: Text(title, style: TextStyle(fontSize: 18)),
            trailing: Icon(
              status == SectionStatus.complete
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: status == SectionStatus.complete
                  ? Colors.blue
                  : Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

enum SectionStatus { incomplete, complete }
