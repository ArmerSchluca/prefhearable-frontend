/// Datenmodell zur Beschreibung des verwendeten Endgeräts.
///
/// Die Informationen werden zusammen mit einer Umfrage gespeichert.
class DeviceInformation {
  String? appVersion;
  String? operatingSystem;
  String? model;

  DeviceInformation({this.appVersion, this.operatingSystem, this.model});

  /// Wandelt die Geräteinformationen in eine JSON-Repräsentation um.
  Map<String, dynamic> toJson() => {
    'appVersion': appVersion,
    'operatingSystem': operatingSystem,
    'model': model,
  };

  DeviceInformation.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
    operatingSystem = json['operatingSystem'];
    model = json['model'];
  }
}
