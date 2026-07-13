class ContextData {
  double? latitude;
  double? longitude;
  LocationType? locationType;
  Season? season;
  double? noiseLevel;
  DateTime? timestamp;
  WeatherData? weather;
  AirQualityData? airQuality;

  bool get isComplete =>
      latitude != null &&
      longitude != null &&
      locationType != null &&
      season != null &&
      noiseLevel != null &&
      timestamp != null &&
      weather!.isComplete &&
      airQuality!.isComplete;

  ContextData({
    this.latitude,
    this.longitude,
    this.locationType,
    this.season,
    this.noiseLevel,
    this.timestamp,
    this.weather,
    this.airQuality,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'locationType': locationType?.name,
    'season': season?.name,
    'noiseLevel': noiseLevel,
    'timestamp': timestamp?.toIso8601String(),
    'weather': weather?.toJson(),
    'airQuality': airQuality?.toJson(),
  };

  ContextData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];

    locationType = json['locationType'] != null
        ? LocationType.values.firstWhere((e) => e.name == json['locationType'])
        : null;

    season = json['season'] != null
        ? Season.values.firstWhere((e) => e.name == json['season'])
        : null;

    noiseLevel = json['noiseLevel'];

    timestamp = json['timestamp'] != null
        ? DateTime.parse(json['timestamp'])
        : null;

    weather = json['weather'] != null
        ? WeatherData.fromJson(json['weather'])
        : null;

    airQuality = json['airQuality'] != null
        ? AirQualityData.fromJson(json['airQuality'])
        : null;
  }
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
  String? description;
  double? temperature;
  double? humidity;
  double? windSpeed;
  double? uvIndex;

  WeatherData({
    this.description,
    this.temperature,
    this.humidity,
    this.windSpeed,
    this.uvIndex,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'temperature': temperature,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'uvIndex': uvIndex,
  };

  WeatherData.fromJson(Map<String, dynamic> json)
    : description = json['description'],
      temperature = (json['temperature'] as num?)?.toDouble(),
      humidity = (json['humidity'] as num?)?.toDouble(),
      windSpeed = (json['windSpeed'] as num?)?.toDouble(),
      uvIndex = (json['uvIndex'] as num?)?.toDouble();

  bool get isComplete =>
      description != null &&
      temperature != null &&
      humidity != null &&
      windSpeed != null &&
      uvIndex != null;
}

class AirQualityData {
  double? europeanAqi;
  double? pm25;
  double? pm10;
  double? nitrogenDioxide;
  double? ozone;

  AirQualityData({
    this.europeanAqi,
    this.pm25,
    this.pm10,
    this.nitrogenDioxide,
    this.ozone,
  });

  Map<String, dynamic> toJson() => {
    'europeanAqi': europeanAqi,
    'pm25': pm25,
    'pm10': pm10,
    'nitrogenDioxide': nitrogenDioxide,
    'ozone': ozone,
  };

  AirQualityData.fromJson(Map<String, dynamic> json)
    : europeanAqi = (json['europeanAqi'] as num?)?.toDouble(),
      pm25 = (json['pm25'] as num?)?.toDouble(),
      pm10 = (json['pm10'] as num?)?.toDouble(),
      nitrogenDioxide = (json['nitrogenDioxide'] as num?)?.toDouble(),
      ozone = (json['ozone'] as num?)?.toDouble();

  bool get isComplete =>
      europeanAqi != null &&
      pm25 != null &&
      pm10 != null &&
      nitrogenDioxide != null &&
      ozone != null;
}
