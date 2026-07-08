import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/services/external_api_service.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/survey_instance.dart';
import 'package:intl/intl.dart';

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
  Season? season;
  final noiseLevelController = TextEditingController();
  final timestampController = TextEditingController();
  DateTime? timestamp;
  // Wetter
  final temperatureController = TextEditingController();
  final humidityController = TextEditingController();
  final windSpeedController = TextEditingController();
  final uvIndexController = TextEditingController();
  final descriptionController = TextEditingController();

  // Hier werden die Felder mit den bereits gespeicherten Daten befüllt
  @override
  void initState() {
    super.initState();

    final contextData = surveyService.currentSurvey!.contextData;

    latitudeController.text = contextData.latitude?.toString() ?? "";
    longitudeController.text = contextData.longitude?.toString() ?? "";
    locationType = contextData.locationType;
    season = contextData.season;
    noiseLevelController.text = contextData.noiseLevel?.toString() ?? "";

    timestamp = contextData.timestamp;
    timestampController.text = contextData.timestamp == null
        ? ""
        : DateFormat("dd.MM.yyyy HH:mm:ss").format(contextData.timestamp!);

    if (contextData.weather != null) {
      temperatureController.text = contextData.weather!.temperature.toString();
      humidityController.text = contextData.weather!.humidity.toString();
      windSpeedController.text = contextData.weather!.windSpeed.toString();
      uvIndexController.text = contextData.weather!.uvIndex.toString();
      descriptionController.text = contextData.weather!.description.toString();
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
          _saveContextData();

          Navigator.pop(context);

          if (!surveyService.currentSurvey!.contextData.isComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Es wurden noch nicht alle Felder ausgefüllt!"),
                backgroundColor: Colors.grey,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Kontextdaten erfasst!"),
                backgroundColor: Colors.green,
              ),
            );
          }
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
              ),

              SizedBox(height: 70),

              // BUTTON FÜR STANDORT UND WETTER ERFASSEN
              Center(
                child: FilledButton(
                  onPressed: getApiData,
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
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
                      SizedBox(width: 12),
                      Flexible(
                        child: AutoSizeText(
                          "Drücken für GPS-Erfassung",
                          maxLines: 1,
                          minFontSize: 12,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ZEITSTEMPEL (timestamp)
              TextFormField(
                readOnly: true,
                controller: timestampController,
                decoration: AppInputStyles.textField(
                  label: "Zeitpunkt",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // LÄNGENGRAD (latitude)
              TextFormField(
                controller: latitudeController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Längengrad",
                  hint: "Wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // BREITENGRAD (longitude)
              TextFormField(
                controller: longitudeController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Breitengrad",
                  hint: "Wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // KLIMAZONE (climateZone)
              Text(
                "Wetterdaten",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              // TEMPERATUR (temprature)
              TextFormField(
                controller: temperatureController,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Temperatur",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // LUFTFEUCHTIGKEIT (humidity)
              TextFormField(
                controller: humidityController,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Luftfeuchtigkeit",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // WINDGESCHWINDKEIT (windSpeed)
              TextFormField(
                controller: windSpeedController,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Windgeschwindigkeit",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // UV-INDEX (uvIndex)
              TextFormField(
                controller: uvIndexController,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "UV-Index",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 30),

              // WETTER (weather)
              TextFormField(
                controller: descriptionController,
                readOnly: true,
                decoration: AppInputStyles.textField(
                  label: "Wetter",
                  hint: "wird automatisch erfasst",
                  accentColor: Colors.green,
                ),
              ),

              SizedBox(height: 70),

              // BUTTON FÜR UMGEBUNGSLAUTSTÄRKE MESSEN
              Center(
                child: FilledButton(
                  onPressed: getNoiseLevel,
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
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
                      Icon(Icons.mic, size: 28),
                      SizedBox(width: 12),
                      Flexible(
                        child: AutoSizeText(
                          "Drücken für Dezibelmessung",
                          maxLines: 1,
                          minFontSize: 12,
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
    final weather = WeatherData(
      description: descriptionController.text,
      temperature: double.tryParse(temperatureController.text) ?? 0,
      humidity: double.tryParse(humidityController.text) ?? 0,
      windSpeed: double.tryParse(windSpeedController.text) ?? 0,
      uvIndex: double.tryParse(uvIndexController.text) ?? 0,
    );

    final contextData = ContextData(
      latitude: double.tryParse(latitudeController.text),
      longitude: double.tryParse(longitudeController.text),
      locationType: locationType,
      season: season,
      noiseLevel: double.tryParse(noiseLevelController.text),
      timestamp: timestamp,
      weather: weather,
    );

    await surveyService.saveContextData(contextData);
  }

  Future<void> getApiData() async {
    final confirmed = await AppDialog.showSelection(
      context,
      Text("GPS zulassen?"),
      Text("GPS zulassen, um alle Felder automatisch auszufüllen?"),
      Colors.green,
      Colors.grey,
    );

    if (confirmed != true) return;

    // Ladebalken vor API-Call öffnen
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          Center(child: CircularProgressIndicator(color: Colors.green)),
    );

    try {
      final position = await ExternalApiService.getCurrentPosition().timeout(
        Duration(seconds: 15),
      );

      final weather = await ExternalApiService.getWeather(
        position.latitude,
        position.longitude,
      ).timeout(Duration(seconds: 15));

      // Ladebalken nach Abschluss der API-Calls schließen
      if (mounted) {
        Navigator.pop(context);
      }

      final timeNow = DateTime.now();

      setState(() {
        latitudeController.text = position.latitude.toStringAsFixed(6);
        longitudeController.text = position.longitude.toStringAsFixed(6);

        temperatureController.text = weather.temperature!.toStringAsFixed(1);
        humidityController.text = weather.humidity!.toStringAsFixed(0);
        windSpeedController.text = weather.windSpeed!.toStringAsFixed(1);
        uvIndexController.text = weather.uvIndex!.toStringAsFixed(1);
        descriptionController.text = weather.description!;

        timestamp = timeNow;
        timestampController.text = DateFormat(
          "dd.MM.yyyy HH:mm:ss",
        ).format(timeNow);
      });

      // Bei Zeitüberschreitung entsprechedne Fehlermeldung
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Zeitüberschreitung beim Erfassen der Daten.")),
      );

      // Für sonstige Fehler, z.B. Permission denied
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Standort konnte nicht ermittelt werden.")),
      );

      // Damit der Ladebalken immer verschwindet, egal ob Success oder Error
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<void> getNoiseLevel() async {
    AppDialog.showInfo(
      context,
      Text("Umgebungslautstärke"),
      Text(
        "Hier wird später die Lautstärke über das Mikrofon automatisch gemessen.",
      ),
    );
  }
}
