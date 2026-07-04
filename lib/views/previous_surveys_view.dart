import 'package:flutter/material.dart';
import 'package:frontend/shared_components/app_dialogs.dart';
import 'package:frontend/shared_components/app_layout.dart';
import 'package:frontend/shared_components/custom_appbar.dart';
import 'package:frontend/shared_components/footer.dart';
import 'package:frontend/views/survey_modules/audiotest_view.dart';
import 'package:frontend/views/survey_modules/context_data_view.dart';
import 'package:frontend/views/survey_modules/person_data_view.dart';
import 'package:frontend/views/survey_modules/questionnaires_view.dart';

class PreviousSurveysView extends StatelessWidget {
  const PreviousSurveysView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      footer: AppFooter(
        actions: [
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
        clipBehavior: .hardEdge,
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
