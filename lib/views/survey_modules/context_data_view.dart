import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/survey_instance.dart';

class ContextDataView extends StatefulWidget {
  const ContextDataView({super.key});

  @override
  State<ContextDataView> createState() => _ContextDataViewState();
}

class _ContextDataViewState extends State<ContextDataView> {
  final _formKey = GlobalKey<FormState>();

  double? latitude;
  double? longitude;
  LocationType? locationType;
  String? climateZone;
  Season? season;
  double? noiseLevel;
  DateTime? timestamp;
  String? weather;

  // Hier werden die Felder mit den bereits gespeicherten Daten befüllt
  @override
  void initState() {
    super.initState();

    final contextData = survey.currentSurvey?.contextData;

    if (contextData != null) {
      latitude = latitude;
      longitude = longitude;
      locationType = locationType;
      climateZone = climateZone;
      season = season;
      noiseLevel = noiseLevel;
      timestamp = timestamp;
      weather = weather;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Kontextdaten",
        color: Colors.green,
        nav: true,
        onBackPressed: () {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Es wurden noch nicht alle Felder ausgefüllt!"),
                backgroundColor: Colors.orange,
              ),
            );
          }
          _saveContextData();
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
        Center(child: Icon(Icons.public, size: 150, color: Colors.green)),
        SizedBox(height: 30),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // LÄNGENGRAD (latitude)
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: AppInputStyles.textField(
                  label: "Längengrad",
                  hint: "",
                  accentColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveContextData() async {
    // Alle Eingaben gesammelt in ein Objekt speichern
    final contextData = ContextData(
      latitude: latitude,
      longitude: longitude,
      locationType: locationType,
      climateZone: climateZone,
      season: season,
      noiseLevel: noiseLevel,
      timestamp: timestamp,
      weather: weather,
    );

    await survey.saveContextData(contextData);
  }
}
