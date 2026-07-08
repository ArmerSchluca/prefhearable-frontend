class ContextData {
  double? latitude;
  double? longitude;
  LocationType? locationType;
  Season? season;
  double? noiseLevel;
  DateTime? timestamp;
  WeatherData? weather;

  bool get isComplete =>
      latitude != null &&
      longitude != null &&
      locationType != null &&
      season != null &&
      noiseLevel != null &&
      timestamp != null &&
      weather!.isWeatherComplete;

  ContextData({
    this.latitude,
    this.longitude,
    this.locationType,
    this.season,
    this.noiseLevel,
    this.timestamp,
    this.weather,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'locationType': locationType?.name,
    'season': season?.name,
    'noiseLevel': noiseLevel,
    'timestamp': timestamp?.toIso8601String(),
    'weather': weather?.toJson(),
  };
}

enum LocationType { indoor, outdoor }

enum Season { spring, summer, autumn, winter }

extension LocationTypeLabel on LocationType {
  String get label {
    switch (this) {
      case LocationType.indoor:
        return "Innen";
      case LocationType.outdoor:
        return "Außen";
    }
  }
}

extension SeasonLabel on Season {
  String get label {
    switch (this) {
      case Season.spring:
        return "Frühling";
      case Season.summer:
        return "Sommer";
      case Season.autumn:
        return "Herbst";
      case Season.winter:
        return "Winter";
    }
  }
}

class WeatherData {
  final String? description;
  final double? temperature;
  final double? humidity;
  final double? windSpeed;
  final double? uvIndex;

  WeatherData({
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'temperature': temperature,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'uvIndex': uvIndex,
  };

  bool get isWeatherComplete =>
      description != null &&
      temperature != null &&
      humidity != null &&
      windSpeed != null &&
      uvIndex != null;
}
