import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/audio_tests/ccsm.dart';
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
  final player = AudioPlayer();

  late SoundRating artificialSound1;
  late SoundRating naturalSound1;
  late SoundRating naturalSound2;

  @override
  void initState() {
    super.initState();

    final ccsm = surveyService.currentSurvey!.audioTestData.ccsm;

    artificialSound1 = ccsm.artificialSound1;
    naturalSound1 = ccsm.naturalSound1;
    naturalSound2 = ccsm.naturalSound2;
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
        Text(
          "Bitte hören Sie sich jeden Klang vollständig an und bewerten Sie ihn anschließend anhand der fünf Eigenschaften.",
          style: TextStyle(fontSize: 16),
        ),

        SizedBox(height: 30),

        _buildSoundCard(
          title: "500 Hz",
          asset: AssetSource('ccsm_audiofiles/500hz.wav'),
          rating: artificialSound1,
        ),

        SizedBox(height: 30),

        _buildSoundCard(
          title: "Haarföhn",
          asset: AssetSource('ccsm_audiofiles/hair_dryer.wav'),
          rating: naturalSound1,
        ),

        SizedBox(height: 30),

        _buildSoundCard(
          title: "Elektrorasierer",
          asset: AssetSource('ccsm_audiofiles/shaver.wav'),
          rating: naturalSound2,
        ),
      ],
    );
  }

  Future<void> _saveCcsm() async {
    await surveyService.saveCcsm(
      surveyService.currentSurvey!.audioTestData.ccsm,
    );
  }

  Widget _buildSoundCard({
    required String title,
    required AssetSource asset,
    required SoundRating rating,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            FilledButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.pinkAccent,
                ),
              ),
              icon: Icon(Icons.play_arrow),
              label: Text("Sound abspielen"),
              onPressed: () async {
                await player.stop();
                await player.play(asset);

                setState(() {
                  rating.hasPlayed = true;
                });
              },
            ),

            SizedBox(height: 20),

            Text("Klingt das Geräusch...", style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 20),

            _slider(
              "...rau?",
              rating.roughness,
              rating.hasPlayed,
              (v) => setState(() => rating.roughness = v),
            ),

            _slider(
              "...scharf?",
              rating.sharpness,
              rating.hasPlayed,
              (v) => setState(() => rating.sharpness = v),
            ),

            _slider(
              "...tonhaltig?",
              rating.tonality,
              rating.hasPlayed,
              (v) => setState(() => rating.tonality = v),
            ),

            _slider(
              "...laut?",
              rating.loudness,
              rating.hasPlayed,
              (v) => setState(() => rating.loudness = v),
            ),

            _slider(
              "...lästig?",
              rating.annoyance,
              rating.hasPlayed,
              (v) => setState(() => rating.annoyance = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(
    String title,
    int psychoacousticParameterValue,
    bool enabled,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title)),
            Text(psychoacousticParameterValue.toString()),
            Slider(
              thumbColor: Colors.pinkAccent,
              activeColor: Colors.pinkAccent,
              min: 0,
              max: 50,
              divisions: 50,
              value: psychoacousticParameterValue.toDouble(),
              onChanged: enabled ? (v) => onChanged(v.round()) : null,
            ),
          ],
        ),

        SizedBox(height: 8),
      ],
    );
  }
}
