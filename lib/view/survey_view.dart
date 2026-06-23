import 'package:flutter/material.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text("Prefhearable", style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SectionCard(
              title: "Personal Data",
              icon: Icon(Icons.person, color: Colors.amber),
              status: SectionStatus.open,
            ),
            SizedBox(height: 12),
            SectionCard(
              title: "Contextual Data",
              icon: Icon(Icons.public, color: Colors.green),
              status: SectionStatus.open,
            ),
            SizedBox(height: 12),
            SectionCard(
              title: "Audio Tests",
              icon: Icon(Icons.headphones, color: Colors.pink),
              status: SectionStatus.open,
            ),
            SizedBox(height: 12),
            SectionCard(
              title: "Questionnaires",
              icon: Icon(Icons.assignment, color: Colors.blue),
              status: SectionStatus.open,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final SectionStatus status;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: .hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
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
