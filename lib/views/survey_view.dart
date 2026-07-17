import 'package:flutter/material.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/info_texts.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/section_card.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/survey_modules/audiotest_view.dart';
import 'package:frontend/views/survey_modules/context_data_view.dart';
import 'package:frontend/views/survey_modules/personal_data_view.dart';
import 'package:frontend/views/survey_modules/questionnaires_view.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Umfrage",
        color: Colors.blueAccent,
        nav: true,
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeView()),
          );
        },
      ),
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
                null,
                null,
              );

              if (result == true) {
                await surveyService.cancelSurvey();
                debugPrint("SURVEY_CANCELT");

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Umfrage abbgebrochen!"),
                    backgroundColor: Colors.green,
                  ),
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
                Text("Umfrage"),
                Text(InfoTexts.survey),
              );
            },
          ),
        ],
      ),
      children: [
        SectionCard(
          title: "Personendaten",
          icon: Icon(Icons.person, color: Colors.orange, size: 40),
          status: surveyService.currentSurvey!.personalData.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PersonalDataView()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Kontextdaten",
          icon: Icon(Icons.public, color: Colors.green, size: 40),
          status: surveyService.currentSurvey!.contextData.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ContextDataView()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Hörtests",
          icon: Icon(Icons.headphones, color: Colors.pinkAccent, size: 40),
          status: surveyService.currentSurvey!.audioTestData.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AudioTestView()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
        SizedBox(height: 12),
        SectionCard(
          title: "Umfragebögen",
          icon: Icon(
            Icons.assignment,
            color: Colors.deepPurpleAccent,
            size: 40,
          ),
          status: surveyService.currentSurvey!.questionnaireData.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QuestionnairesView()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),

        SizedBox(height: 50),

        //  SUBMIT BUTTON
        Center(
          child: FilledButton(
            onPressed: surveyService.currentSurvey!.isComplete
                ? () async {
                    try {
                      await surveyService.submitSurvey();

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomeView()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Daten übermittelt! Vielen Dank für Ihre Teilnahme!",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Daten konnten nicht übermittelt werden. Bitte versuche es später erneut!",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                : null,
            style: FilledButton.styleFrom(
              elevation: 3,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),

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
