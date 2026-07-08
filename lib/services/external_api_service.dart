import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ExternalApiService {
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("LOCATION_DISABLED");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint("Permission: $permission");

    final enabled = await Geolocator.isLocationServiceEnabled();
    debugPrint("Location enabled: $enabled");

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

  static Future<WeatherData> getWeather(
    double latitude,
    double longitude,
  ) async {
    final response = await http.get(
      Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$latitude"
        "&longitude=$longitude"
        "&current="
        "temperature_2m,"
        "relative_humidity_2m,"
        "wind_speed_10m,"
        "weather_code,"
        "uv_index",
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("WEATHER_API_FAILED");
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

  /// Basierend auf WMO Weather Codes. Hier wurden die wichtigsten ausgesucht
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
