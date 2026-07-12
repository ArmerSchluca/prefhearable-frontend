class DeviceInformation {
  String? appVersion;
  String? operatingSystem;
  String? model;

  DeviceInformation({this.appVersion, this.operatingSystem, this.model});

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
