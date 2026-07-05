class ContextData {
  double? latitude;
  double? longitude;
  LocationType? locationType;
  String? climateZone;
  Season? season;
  double? noiseLevel;
  DateTime? timestamp;
  String? weather;

  // Zum Abfragen des Status, ob alle Felder ausgefüllt
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
