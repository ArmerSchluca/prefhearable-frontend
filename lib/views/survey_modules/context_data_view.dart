import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/input_validator.dart';
import 'package:frontend/utils/survey_instance.dart';

class ContextDataView extends StatefulWidget {
  const ContextDataView({super.key});

  @override
  State<ContextDataView> createState() => _ContextDataViewState();
}

class _ContextDataViewState extends State<ContextDataView> {
  final _formKey = GlobalKey<FormState>();

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  LocationType? locationType;
  String? climateZone;
  Season? season;
  final noiseLevelController = TextEditingController();
  DateTime? timestamp;
  final weatherController = TextEditingController();

  // Hier werden die Felder mit den bereits gespeicherten Daten befüllt
  @override
  void initState() {
    super.initState();

    final contextData = survey.currentSurvey?.contextData;

    if (contextData != null) {
      latitudeController.text = contextData.latitude?.toString() ?? "";
      longitudeController.text = contextData.longitude?.toString() ?? "";
      locationType = contextData.locationType;
      climateZone = contextData.climateZone;
      season = contextData.season;
      noiseLevelController.text = contextData.noiseLevel?.toString() ?? "";
      timestamp = contextData.timestamp;
      weatherController.text = contextData.weather?.toString() ?? "";
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
                backgroundColor: Colors.grey,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Kontextdaten erfasst!"),
                backgroundColor: Colors.green,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              // AUFENTHALTSORT (locationType)
              DropdownButtonFormField<LocationType>(
                decoration: AppInputStyles.dropdown(
                  label: "Aufenthaltsort",
                  hint: "Bitte Aufenthaltsort auswählen",
                  accentColor: Colors.green,
                ),
                initialValue: locationType,
                items: LocationType.values.map((locationType) {
                  return DropdownMenuItem(
                    value: locationType,
                    child: Text(locationType.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    locationType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Aufenthaltsort auswählen.";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),

              // JAHRESZEIT (season)
              DropdownButtonFormField<Season>(
                decoration: AppInputStyles.dropdown(
                  label: "Jahreszeit",
                  hint: "Bitte die aktuelle Jahreszeit auswählen",
                  accentColor: Colors.green,
                ),
                initialValue: season,
                items: Season.values.map((season) {
                  return DropdownMenuItem(
                    value: season,
                    child: Text(season.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    season = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Jahreszeit auswählen.";
                  }
                  return null;
                },
              ),

              SizedBox(height: 70),

              // STANDORT UND WETTER ERFASSEN
              Center(
                child: FilledButton(
                  onPressed: getApiData,
                  style: FilledButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_location_alt_outlined, size: 28),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Hier drücken für GPS-Erfassung",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // LÄNGENGRAD (latitude)
              TextFormField(
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Längengrad",
                  hint: "Wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // KLIMAZONE (climateZone)
              TextFormField(
                initialValue: climateZone,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Klimaregion",
                  hint: "Wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // WETTER (weather)
              TextFormField(
                controller: weatherController,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Wetter",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // ZEITSTEMPEL (timestamp)
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: timestamp?.toString() ?? "",
                ),
                decoration: AppInputStyles.textField(
                  label: "Zeitpunkt",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 70),

              // UMGEBUNGSLAUTSTÄRKE
              Center(
                child: FilledButton(
                  onPressed: getNoiseLevel,
                  style: FilledButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.graphic_eq, size: 28),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Hier drücken für Dezibelmessung",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // LAUTSTÄRKE (noiseLevel)
              TextFormField(
                controller: noiseLevelController,
                readOnly: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: AppInputStyles.textField(
                  label: "Umgebungslautstärke",
                  hint: "wird automatisch erfasst",
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
      latitude: double.tryParse(latitudeController.text),
      longitude: double.tryParse(longitudeController.text),
      locationType: locationType,
      climateZone: climateZone,
      season: season,
      noiseLevel: double.tryParse(noiseLevelController.text),
      timestamp: timestamp,
      weather: weatherController.text,
    );

    await survey.saveContextData(contextData);
  }

  Future<void> getApiData() async {
    AppDialog.showSelection(
      context,
      Text("GPS zulassen?"),
      Text("GPS zulassen, um alle Felder automatisch auszufüllen?"),
      Colors.green,
      Colors.grey,
    );
    timestamp = null;
    timestamp = DateTime.now();
  }

  Future<void> getNoiseLevel() async {
    AppDialog.showInfo(
      context,
      const Text("Umgebungslautstärke"),
      const Text(
        "Hier wird später die Lautstärke über das Mikrofon automatisch gemessen.",
      ),
    );
  }
}
