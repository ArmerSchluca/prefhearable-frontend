import 'package:flutter/material.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/section_card.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:frontend/views/survey_modules/audio_tests/ccsm_view.dart';

class AudioTestView extends StatefulWidget {
  const AudioTestView({super.key});

  @override
  State<AudioTestView> createState() => _AudioTestViewState();
}

class _AudioTestViewState extends State<AudioTestView> {
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
                Text("Infos zu Hörtests"),
                Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut "
                  "labore et dolore magna aliquyam erat, sed diam voluptua.At vero eos et accusam et justo duo dolores et ea rebum. ",
                ),
              );
            },
          ),
        ],
      ),
      appBar: CustomAppBar(
        title: "Hörtests",
        color: Colors.pinkAccent,
        nav: true,
      ),
      children: [
        // EQ-5D CARD
        SectionCard(
          title: "CCSM Audio Test",
          icon: Icon(Icons.hearing, color: Colors.pinkAccent, size: 40),
          status: surveyService.currentSurvey!.audioTestData.ccsm.isComplete
              ? SectionStatus.complete
              : SectionStatus.incomplete,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CcsmAudioTestView()),
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
      ],
    );
  }
}
