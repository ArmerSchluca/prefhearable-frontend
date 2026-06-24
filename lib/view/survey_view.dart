import 'package:flutter/material.dart';
import 'package:frontend/util/custom_appbar.dart';
import 'package:frontend/view/survey_data_pages/audiotest_page.dart';
import 'package:frontend/view/survey_data_pages/context_data_page.dart';
import 'package:frontend/view/survey_data_pages/personal_data_page.dart';
import 'package:frontend/view/survey_data_pages/questionnaires_page.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Umfrage", backgroundColor: Colors.blue),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SectionCard(
              title: "Personal Data",
              icon: Icon(Icons.person, color: Colors.orange, size: 40,),
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
              icon: Icon(Icons.assignment, color: Colors.deepPurpleAccent, size: 40),
              status: SectionStatus.open,
              destination: QuestionnairesView(),
            ),
          ],
        ),
      ),
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
