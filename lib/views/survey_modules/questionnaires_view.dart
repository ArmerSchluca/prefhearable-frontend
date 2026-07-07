import 'package:flutter/material.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/section_card.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:frontend/views/survey_modules/questionnaires/eq5d_view.dart';
import 'package:frontend/views/survey_modules/questionnaires/who5_view.dart';

class QuestionnairesView extends StatefulWidget {
  const QuestionnairesView({super.key});

  @override
  State<QuestionnairesView> createState() => _QuestionnairesViewState();
}

class _QuestionnairesViewState extends State<QuestionnairesView> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      footer: AppFooter(
        actions: [
          // Damit der Info Button rechts aligned ist
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
                const Text("Infos zur Umfrage"),
                const Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut "
                  "labore et dolore magna aliquyam erat, sed diam voluptua.At vero eos et accusam et justo duo dolores et ea rebum. ",
                ),
              );
            },
          ),
        ],
      ),
      appBar: CustomAppBar(
        title: "Umfragebögen",
        color: Colors.deepPurpleAccent,
        nav: true,
      ),
      children: [
        // EQ-5D CARD
        SectionCard(
          title: "EQ-5D",
          icon: Icon(
            Icons.notes_outlined,
            color: Colors.deepPurpleAccent,
            size: 40,
          ),
          status: survey.currentSurvey!.questionnaireData!.eq5d.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Eq5dView()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
        SizedBox(height: 12),

        // WHO-5 CARD
        SectionCard(
          title: "WHO-5",
          icon: Icon(
            Icons.notes_outlined,
            color: Colors.deepPurpleAccent,
            size: 40,
          ),
          status: survey.currentSurvey!.questionnaireData!.who5.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Who5View()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
      ],
    );
  }
}
