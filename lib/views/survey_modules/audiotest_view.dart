import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/audiotest_data.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/survey_instance.dart';

class AudioTestView extends StatefulWidget {
  const AudioTestView({super.key});

  @override
  State<AudioTestView> createState() => _AudioTestViewState();
}

class _AudioTestViewState extends State<AudioTestView> {
  final _formKey = GlobalKey<FormState>();

  int? age;

  @override
  void initState() {
    super.initState();

    final audioTestData = survey.currentSurvey?.audioTestData;

    if (audioTestData != null) {
      age = audioTestData.age;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Personendaten",
        color: Colors.pinkAccent,
        nav: true,
        onBackPressed: () {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Es wurden noch nicht alle Felder ausgefüllt!"),
                backgroundColor: Colors.grey,
              ),
            );
          }
          _saveAudioTestData();
          Navigator.pop(context);
        },
      ),
      footer: AppFooter(
        actions: [
          Spacer(),
          // INFO BUTTON
          TextButton.icon(
            icon: Icon(Icons.info, size: 20, color: Colors.blueGrey),
            label: Text(
              "Info",
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
            onPressed: () {
              AppDialog.showInfo(context, Text("Titel"), Text("Lorem ipsum"));
            },
          ),
        ],
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: AppInputStyles.textField(
                  label: "Alter",
                  hint: "z. B. 25",
                  accentColor: Colors.pinkAccent,
                ),
                validator: (value) {
                  if (value != null) {
                    final number = int.tryParse(value);

                    if (number != null && number <= 0) {
                      return "Bitte eine positive Ganzzahl eingeben.";
                    }
                  }
                  return "Bitte Alter angeben.";
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveAudioTestData() async {
    // Alle Eingaben gesammelt in ein Objekt speichern
    final audioTestData = AudioTestData(age: age);

    await survey.saveAudioTestData(audioTestData);
  }
}
