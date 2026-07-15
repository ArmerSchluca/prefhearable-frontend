import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service für die Erfassung der Kontextdaten über externe Dienste und Gerätesensoren.
class ExternalApiService {
  /// Ermittelt den durchschnittlichen Umgebungsgeräuschpegel.
  ///
  /// Die Lautstärke wird über einen Zeitraum von drei Sekunden gemessen und
  /// als gemittelter Dezibelwert zurückgegeben.
  static Future<double> measureDecibels() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!await Permission.microphone.isGranted) {
        final result = await Permission.microphone.request();
        
        if (!result.isGranted) {
          throw Exception("MIC_PERMISSION_DENIED");
        }
      }
    }

    final noiseMeter = NoiseMeter();

    final values = <double>[];
    final completer = Completer<double>();

    late final StreamSubscription<NoiseReading> subscription;

    subscription = noiseMeter.noise.listen(
      (NoiseReading reading) async {
        if (reading.meanDecibel.isFinite) {
          values.add(reading.meanDecibel);
        }
      },

      onError: (Object error) async {
        await subscription.cancel();

        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    // 3 Sekunden messen
    Future.delayed(const Duration(seconds: 3), () async {
      await subscription.cancel();

      if (values.isEmpty) {
        if (!completer.isCompleted) {
          completer.completeError(Exception("NO_NOISE_DATA"));
        }
        return;
      }

      final average = values.reduce((a, b) => a + b) / values.length;

      if (!completer.isCompleted) {
        completer.complete(average);
      }
    });

    return completer.future;
  }

  /// Ermittelt die aktuelle Position des Geräts.
  ///
  /// Vor dem Abruf werden der Standortdienst sowie die erforderlichen
  /// Berechtigungen überprüft. Bei fehlenden Voraussetzungen wird eine
  /// entsprechende Exception ausgelöst.
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("LOCATION_DISABLED");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("LOCATION_DENIED");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("LOCATION_DENIED_FOREVER");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  /// Ruft die aktuellen Wetterdaten für die angegebene Position ab.
  ///
  /// Die Wetterinformationen werden über die Open-Meteo Forecast-API als JSON bezogen.
  static Future<WeatherData> getWeather(
    double latitude,
    double longitude,
  ) async {
    final response = await http.get(
      Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$latitude"
        "&longitude=$longitude"
        // Units
        "&current=" // iso8601 (time)
        "temperature_2m," // °C
        "relative_humidity_2m," // %
        "wind_speed_10m," // km/h
        "weather_code," // wmo code
        "uv_index", // index
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("WEATHER_FORECAST_API_FAILED");
    }

    final data = jsonDecode(response.body);

    final current = data["current"];

    return WeatherData(
      description: _weatherCodeToString(current["weather_code"]),
      temperature: (current["temperature_2m"] as num).toDouble(),
      humidity: (current["relative_humidity_2m"] as num).toDouble(),
      windSpeed: (current["wind_speed_10m"] as num).toDouble(),
      uvIndex: (current["uv_index"] as num).toDouble(),
    );
  }

  /// Ruft die aktuellen Luftqualitätsdaten für die angegebene Position ab.
  ///
  /// Die Daten werden über die Open-Meteo Air-Quality-API als JSON bezogen.
  static Future<AirQualityData> getAirQuality(
    double latitude,
    double longitude,
  ) async {
    final response = await http.get(
      Uri.parse(
        "https://air-quality-api.open-meteo.com/v1/air-quality"
        "?latitude=$latitude"
        "&longitude=$longitude"
        "&current="
        "european_aqi,"
        "pm2_5,"
        "pm10,"
        "nitrogen_dioxide,"
        "ozone",
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("AIR_QUALITY_API_FAILED");
    }

    final data = jsonDecode(response.body);
    final current = data["current"];

    return AirQualityData(
      europeanAqi: (current["european_aqi"] as num).toDouble(),
      pm25: (current["pm2_5"] as num).toDouble(),
      pm10: (current["pm10"] as num).toDouble(),
      nitrogenDioxide: (current["nitrogen_dioxide"] as num).toDouble(),
      ozone: (current["ozone"] as num).toDouble(),
    );
  }

  /// Übersetzt WMO-Wettercodes in eine deutschsprachige Beschreibung.
  ///
  /// Es werden die für die Anwendung relevanten Wettercodes berücksichtigt.
  static String _weatherCodeToString(int code) {
    switch (code) {
      case 0:
        return "Sonnig";

      case 1:
      case 2:
        return "Leicht bewölkt";

      case 3:
        return "Bewölkt";

      case 45:
      case 48:
        return "Nebel";

      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return "Nieselregen";

      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return "Regen";

      case 71:
      case 73:
      case 75:
      case 77:
        return "Schnee";

      case 80:
      case 81:
      case 82:
        return "Regenschauer";

      case 85:
      case 86:
        return "Schneeschauer";

      case 95:
      case 96:
      case 99:
        return "Gewitter";

      default:
        return "Unbekannt";
    }
  }
}
