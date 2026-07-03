class DeviceInformation {
  String operatingSystem;
  String model;
  String audioDevice;

  DeviceInformation({
    required this.operatingSystem,
    required this.model,
    required this.audioDevice,
  });

  Map<String, dynamic> toJson() => {
    'operatingSystem': operatingSystem,
    'model': model,
    'audioDevice': audioDevice,
  };
}