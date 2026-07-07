import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/questionnaires/eq5d.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/survey_instance.dart';

class Eq5dView extends StatefulWidget {
  const Eq5dView({super.key});

  @override
  State<Eq5dView> createState() => _Eq5dViewState();
}

class _Eq5dViewState extends State<Eq5dView> {
  Eq5dLevel? mobility;
  Eq5dLevel? selfCare;
  Eq5dLevel? usualActivities;
  Eq5dLevel? pain;
  Eq5dLevel? anxiety;

  final mobilityAnswers = [
    "Ich habe keine Probleme herumzugehen.",
    "Ich habe leichte Probleme herumzugehen.",
    "Ich habe mäßige Probleme herumzugehen.",
    "Ich habe große Probleme herumzugehen.",
    "Ich bin nicht in der Lage herumzugehen.",
  ];

  final selfCareAnswers = [
    "Ich habe keine Probleme, mich selbst zu waschen oder anzuziehen.",
    "Ich habe leichte Probleme, mich selbst zu waschen oder anzuziehen.",
    "Ich habe mäßige Probleme, mich selbst zu waschen oder anzuziehen.",
    "Ich habe große Probleme, mich selbst zu waschen oder anzuziehen.",
    "Ich bin nicht in der Lage, mich selbst zu waschen oder anzuziehen.",
  ];

  final usualActivityAnswers = [
    "Ich habe keine Probleme, meinen üblichen Tätigkeiten nachzugehen.",
    "Ich habe leichte Probleme, meinen üblichen Tätigkeiten nachzugehen.",
    "Ich habe mäßige Probleme, meinen üblichen Tätigkeiten nachzugehen.",
    "Ich habe große Probleme, meinen üblichen Tätigkeiten nachzugehen.",
    "Ich bin nicht in der Lage, meinen üblichen Tätigkeiten nachzugehen.",
  ];

  final painAnswers = [
    "Ich habe keine Schmerzen oder Beschwerden.",
    "Ich habe leichte Schmerzen oder Beschwerden.",
    "Ich habe mäßige Schmerzen oder Beschwerden.",
    "Ich habe starke Schmerzen oder Beschwerden.",
    "Ich habe extreme Schmerzen oder Beschwerden.",
  ];

  final anxietyAnswers = [
    "Ich bin nicht ängstlich oder deprimiert.",
    "Ich bin ein wenig ängstlich oder deprimiert.",
    "Ich bin mäßig ängstlich oder deprimiert.",
    "Ich bin sehr ängstlich oder deprimiert.",
    "Ich bin extrem ängstlich oder deprimiert.",
  ];

  @override
  void initState() {
    super.initState();

    final eq5d = survey.currentSurvey?.questionnaireData?.eq5d;

    if (eq5d != null) {
      mobility = eq5d.mobility;
      selfCare = eq5d.selfCare;
      usualActivities = eq5d.usualActivities;
      pain = eq5d.pain;
      anxiety = eq5d.anxiety;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "EQ-5D-5L",
        color: Colors.deepPurple,
        nav: true,
        onBackPressed: () async {
          await _saveEq5d();
          if (context.mounted) Navigator.pop(context);
        },
      ),
      footer: AppFooter(
        actions: [
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.info, color: Colors.blueGrey),
            label: const Text("Info", style: TextStyle(color: Colors.blueGrey)),
            onPressed: () {
              AppDialog.showInfo(
                context,
                const Text("EQ-5D-5L"),
                const Text(
                  "Bitte wählen Sie für jede Aussage die Antwort aus, die Ihre aktuelle Situation am besten beschreibt.",
                ),
              );
            },
          ),
        ],
      ),
      children: [
        const Center(
          child: Icon(Icons.assignment, size: 120, color: Colors.deepPurple),
        ),

        SizedBox(height: 30),

        Text(
          "Bitte wählen Sie unter jeder Überschrift DAS Kästchen aus, dass Ihre Gesundheit HEUTE am besten beschreibt.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 30),

        _question(
          Text(
            "BEWEGLICHKEIT / MOBILITÄT",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          mobility,
          (v) => setState(() => mobility = v),
          mobilityAnswers,
        ),

        _question(
          Text(
            "FÜR SICH SELBST SORGEN",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          selfCare,
          (v) => setState(() => selfCare = v),
          selfCareAnswers,
        ),

        _question(
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "ALLTÄGLICHE TÄTIGKEITEN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text:
                      " (z.B. Arbeit, Studium, Hausarbeit, Familien- oder Freizeitaktivitäten)",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          usualActivities,
          (v) => setState(() => usualActivities = v),
          usualActivityAnswers,
        ),

        _question(
          Text(
            "SCHMERZEN / KÖRPERLICHE BESCHWERDEN",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          pain,
          (v) => setState(() => pain = v),
          painAnswers,
        ),

        _question(
          Text(
            "ANGST / NIEDERGESCHLAGENHEIT",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          anxiety,
          (v) => setState(() => anxiety = v),
          anxietyAnswers,
        ),
      ],
    );
  }

  Widget _question(
    Widget title,
    Eq5dLevel? value,
    ValueChanged<Eq5dLevel?> onChanged,
    List<String> answers,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,

          SizedBox(height: 10),

          for (int i = 0; i < answers.length; i++)
            RadioListTile<Eq5dLevel>(
              contentPadding: EdgeInsets.zero,
              value: Eq5dLevel.values[i],
              groupValue: value,
              onChanged: onChanged,
              title: Text(answers[i]),
            ),
        ],
      ),
    );
  }

  Future<void> _saveEq5d() async {
    final eq5d = Eq5d(
      mobility: mobility,
      selfCare: selfCare,
      usualActivities: usualActivities,
      pain: pain,
      anxiety: anxiety,
    );

    survey.saveEq5d(eq5d);
  }
}
