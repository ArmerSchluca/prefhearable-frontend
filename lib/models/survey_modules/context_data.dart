class ContextData {
  double? latitude;
  double? longitude;
  LocationType? locationType;
  String? climateZone;
  Season? season;
  double? noiseLevel;
  DateTime? timestamp;
  String? weather;

  bool get isComplete =>
      latitude != null &&
      longitude != null &&
      locationType != null &&
      climateZone != null &&
      season != null &&
      noiseLevel != null &&
      timestamp != null &&
      weather != null;

  ContextData({
    this.latitude,
    this.longitude,
    this.locationType,
    this.climateZone,
    this.season,
    this.noiseLevel,
    this.timestamp,
    this.weather,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'locationType': locationType?.name,
    'climateZone': climateZone,
    'season': season?.name,
    'noiseLevel': noiseLevel,
    'timestamp': timestamp?.toIso8601String(),
    'weather': weather,
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
