import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/services/context_data_api_service.dart';
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

  late final ContextData contextData;

  // Hier werden die Felder mit den bereits gespeicherten Daten befüllt
  @override
  void initState() {
    super.initState();
    contextData = surveyService.currentSurvey!.contextData;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Kontextdaten",
        color: Colors.green,
        nav: true,
        onBackPressed: () {
          surveyService.saveContextData(contextData);

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
                initialValue: contextData.locationType,
                items: LocationType.values.map((locationType) {
                  return DropdownMenuItem(
                    value: locationType,
                    child: Text(locationType.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    contextData.locationType = value;
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
                initialValue: contextData.season,
                items: Season.values.map((season) {
                  return DropdownMenuItem(
                    value: season,
                    child: Text(season.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    contextData.season = value;
                  });
                },
              ),

              SizedBox(height: 50),

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

              SizedBox(height: 10),

              // LAUTSTÄRKE (noiseLevel)
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.green),
                title: const Text("Lautstärke in Dezibel"),
                subtitle: Text(
                  "${contextData.noiseLevel?.toStringAsFixed(1) ?? "-"} dB",
                ),
              ),

              SizedBox(height: 50),

              // BUTTON FÜR STANDORT UND WETTER ERFASSEN
              Center(
                child: FilledButton(
                  onPressed: _getApiData,
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

              Text(
                "Automatisch erfasste Kontextdaten",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              buildInfoTile(
                icon: Icons.schedule,
                title: "Zeitpunkt",
                value: contextData.timestamp == null
                    ? "-"
                    : DateFormat(
                        "dd.MM.yyyy HH:mm:ss",
                      ).format(contextData.timestamp!),
              ),

              buildInfoTile(
                icon: Icons.location_on,
                title: "Standort",
                value:
                    "${contextData.latitude?.toStringAsFixed(6) ?? "-"}, "
                    "${contextData.longitude?.toStringAsFixed(6) ?? "-"}",
              ),

              Divider(),

              Text(
                "Wetter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              buildInfoTile(
                icon: Icons.cloud,
                title: "Beschreibung",
                value: contextData.weather?.description ?? "-",
              ),

              buildInfoTile(
                icon: Icons.thermostat,
                title: "Temperatur",
                value:
                    "${contextData.weather?.temperature?.toStringAsFixed(1) ?? "-"} °C",
              ),

              buildInfoTile(
                icon: Icons.water_drop,
                title: "Luftfeuchtigkeit",
                value:
                    "${contextData.weather?.humidity?.toStringAsFixed(0) ?? "-"} %",
              ),

              buildInfoTile(
                icon: Icons.air,
                title: "Windgeschwindigkeit",
                value:
                    "${contextData.weather?.windSpeed?.toStringAsFixed(1) ?? "-"} km/h",
              ),

              buildInfoTile(
                icon: Icons.wb_sunny_outlined,
                title: "UV-Index",
                value: contextData.weather?.uvIndex?.toStringAsFixed(1) ?? "-",
              ),

              Divider(),

              Text(
                "Luftqualität",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              buildInfoTile(
                icon: Icons.eco,
                title: "European AQI",
                value:
                    contextData.airQuality?.europeanAqi?.toStringAsFixed(0) ??
                    "-",
              ),

              buildInfoTile(
                icon: Icons.blur_on,
                title: "PM2.5",
                value:
                    "${contextData.airQuality?.pm25?.toStringAsFixed(1) ?? "-"} µg/m³",
              ),

              buildInfoTile(
                icon: Icons.blur_on,
                title: "PM10",
                value:
                    "${contextData.airQuality?.pm10?.toStringAsFixed(1) ?? "-"} µg/m³",
              ),

              buildInfoTile(
                icon: Icons.factory,
                title: "Stickstoffdioxid",
                value:
                    "${contextData.airQuality?.nitrogenDioxide?.toStringAsFixed(1) ?? "-"} µg/m³",
              ),

              buildInfoTile(
                icon: Icons.sunny,
                title: "Ozon",
                value:
                    "${contextData.airQuality?.ozone?.toStringAsFixed(1) ?? "-"} µg/m³",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _getApiData() async {
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
    AppDialog.showLoadingIndicator(
      context,
      Colors.green,
      "Umgebungsdaten werden erfasst, \nbitte warten.",
    );

    try {
      final position = await ExternalApiService.getCurrentPosition().timeout(
        Duration(seconds: 15),
      );

      double lat = position.latitude;
      double long = position.longitude;

      final weather = await ExternalApiService.getWeather(
        lat,
        long,
      ).timeout(Duration(seconds: 15));

      final airQuality = await ExternalApiService.getAirQuality(
        lat,
        long,
      ).timeout(Duration(seconds: 15));

      // Ladebalken nach Abschluss der API-Calls schließen
      if (mounted) {
        Navigator.pop(context);
      }

      setState(() {
        contextData.latitude = lat;
        contextData.longitude = long;
        contextData.weather = weather;
        contextData.airQuality = airQuality;
        contextData.timestamp = DateTime.now();
      });

      await surveyService.saveContextData(contextData);

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
      debugPrint(e.toString());
    }
  }

  Future<void> getNoiseLevel() async {
    final start = await AppDialog.showNoiseCountdown(context);

    if (!start || !mounted) return;

    AppDialog.showLoadingIndicator(
      context,
      Colors.green,
      "Umgebungslautstärke wird gemessen...\nBitte bleiben Sie möglichst ruhig.",
    );

    try {
      final noise = await ExternalApiService.measureDecibels();

      if (!mounted) return;

      Navigator.pop(context);

      contextData.noiseLevel = noise;
      await surveyService.saveContextData(contextData);
      setState(() {});
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Die Lautstärke konnte nicht gemessen werden."),
        ),
      );
    }
  }

  Widget buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
