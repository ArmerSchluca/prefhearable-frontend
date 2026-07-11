import 'package:frontend/models/device_information.dart';

class Participant {
  final String participantId;
  final DeviceInformation deviceInformation;

  Participant({
    required this.participantId,
    required this.deviceInformation,
  });
}
