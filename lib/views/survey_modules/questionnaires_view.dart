import 'package:flutter/material.dart';
import 'package:frontend/shared_components/app_layout.dart';
import 'package:frontend/shared_components/custom_appbar.dart';

class QuestionnairesView extends StatelessWidget {
  const QuestionnairesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Fragebögen",
        color: Colors.deepPurpleAccent,
        nav: true,
      ),
      children: [
        Text("Lorem Ipsum"),
        SizedBox(height: 12),
        Text("Lorem Ipsum"),
        SizedBox(height: 12),
        Text("Lorem Ipsum"),
        SizedBox(height: 12),
        Text("Lorem Ipsum"),
      ],
    );
  }
}
