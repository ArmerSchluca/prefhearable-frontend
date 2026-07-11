class DeviceInformation {
  String? appVersion;
  String? operatingSystem;
  String? model;

  DeviceInformation();

  DeviceInformation.withParams(
    this.appVersion,
    this.operatingSystem,
    this.model
  );

  Map<String, dynamic> toJson() => {
    'appVersion': appVersion,
    'operatingSystem': operatingSystem,
    'model': model,
  };
}
