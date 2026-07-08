import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/audiotest_data.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/survey_instance.dart';

class CcsmAudioTestView extends StatefulWidget {
  const CcsmAudioTestView({super.key});

  @override
  State<CcsmAudioTestView> createState() => _CcsmAudioTestViewState();
}

class _CcsmAudioTestViewState extends State<CcsmAudioTestView> {
  @override
  void initState() {
    super.initState();

    surveyService.currentSurvey!.audioTestData.ccsm;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "CCSM Audiotest",
        color: Colors.pinkAccent,
        nav: true,
        onBackPressed: () async {
          await _saveCcsm();
          if (!context.mounted) return;
          Navigator.pop(context);
        },
      ),
      footer: AppFooter(
        actions: [
          Spacer(),
          TextButton.icon(
            icon: Icon(Icons.info, color: Colors.blueGrey),
            label: Text("Info", style: TextStyle(color: Colors.blueGrey)),
            onPressed: () {
              AppDialog.showInfo(
                context,
                Text("CCSM Audio Test"),
                Text("Lorem Ipsum"),
              );
            },
          ),
        ],
      ),
      children: [
        Center(
          child: Icon(Icons.headphones, size: 120, color: Colors.pinkAccent),
        ),

        SizedBox(height: 30),
      ],
    );
  }

  Future<void> _saveCcsm() async {
    final ccsm = CcsmAudioTest();

    surveyService.saveCcsm(ccsm);
  }
}
