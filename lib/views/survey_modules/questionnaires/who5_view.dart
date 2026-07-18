import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/questionnaires/who5.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/info_texts.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/save_and_continue.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:frontend/views/survey_modules/questionnaires_view.dart';
import 'package:frontend/views/survey_view.dart';

class Who5View extends StatefulWidget {
  const Who5View({super.key});

  @override
  State<Who5View> createState() => _Who5ViewState();
}

class _Who5ViewState extends State<Who5View> {
  Who5Answer? positiveAffect;
  Who5Answer? calmness;
  Who5Answer? vitality;
  Who5Answer? restedness;
  Who5Answer? lifeInterest;

  @override
  void initState() {
    super.initState();

    final who5 = surveyService.currentSurvey!.questionnaireData.who5;

    positiveAffect = who5.positiveAffect;
    calmness = who5.calmness;
    vitality = who5.vitality;
    restedness = who5.restedness;
    lifeInterest = who5.lifeInterest;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "WHO-5",
        color: Colors.deepPurple,
        nav: true,
        onBackPressed: () {
          _saveWho5();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionnairesView()),
          );

          if (!surveyService.currentSurvey!.questionnaireData.who5.isComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Es wurden noch nicht alle Fragen beantworten!"),
                backgroundColor: Colors.grey,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("WHO-5 Umfragebogen abgeschlossen!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
      footer: AppFooter(
        actions: [
          TextButton.icon(
            icon: Icon(Icons.info, color: Colors.blueGrey),
            label: Text("Info", style: TextStyle(color: Colors.blueGrey)),
            onPressed: () {
              AppDialog.showInfo(context, Text("WHO-5"), Text(InfoTexts.who5));
            },
          ),

          // WEITER BUTTON
          SaveAndContinueButton(
            onPressed: () async {
              _saveWho5();

              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurveyView()),
              );
            },
          ),
        ],
      ),
      children: [
        Center(
          child: Icon(Icons.assignment, size: 120, color: Colors.deepPurple),
        ),

        SizedBox(height: 30),

        Text(
          "In den letzten zwei Wochen...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 20),

        _question(
          "...war ich froh und guter Laune",
          positiveAffect,
          (value) => setState(() => positiveAffect = value),
        ),

        _question(
          "...habe ich mich ruhig und entspannt gefühlt",
          calmness,
          (value) => setState(() => calmness = value),
        ),

        _question(
          "...habe ich mich energisch und aktiv gefühlt",
          vitality,
          (value) => setState(() => vitality = value),
        ),

        _question(
          "...habe ich mich beim Aufwachen frisch und ausgeruht gefühlt",
          restedness,
          (value) => setState(() => restedness = value),
        ),

        _question(
          "...war mein Alltag voller Dinge, die mich interessieren",
          lifeInterest,
          (value) => setState(() => lifeInterest = value),
        ),
      ],
    );
  }

  Widget _question(
    String title,
    Who5Answer? value,
    ValueChanged<Who5Answer> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),

          SizedBox(height: 12),

          SegmentedButton<Who5Answer>(
            showSelectedIcon: false,
            emptySelectionAllowed: true,
            segments: Who5Answer.values
                .map(
                  (answer) => ButtonSegment(
                    value: answer,
                    label: Text(answer.value.toString()),
                    tooltip: answer.label,
                  ),
                )
                .toList(),
            selected: value == null ? {} : {value},
            onSelectionChanged: (selection) {
              onChanged(selection.first);
            },
          ),

          if (value != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(value.label, style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  Future<void> _saveWho5() async {
    final who5 = Who5(
      positiveAffect: positiveAffect,
      calmness: calmness,
      vitality: vitality,
      restedness: restedness,
      lifeInterest: lifeInterest,
    );

    surveyService.saveWho5(who5);
  }
}
