import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/device_information.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_audio_output/flutter_audio_output.dart';

class DeviceInformationService {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future<DeviceInformation> getDeviceInformation() async {
    return DeviceInformation(
      appVersion: await getAppVersion(),
      operatingSystem: await getOperatingSystem(),
      model: await getModel(),
    );
  }

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getOperatingSystem() async {
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return "Android ${info.version.release}";
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return "iOS ${info.systemVersion}";
    }

    if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      return "macOS ${info.osRelease}";
    }

    if (Platform.isWindows) {
      return "Windows";
    }

    return Platform.operatingSystem;
  }

  static Future<String> getModel() async {
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return "${info.manufacturer} ${info.model}";
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.utsname.machine;
    }

    if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      return info.model;
    }

    if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      return info.computerName;
    }

    return "Unknown";
  }

  static Future<String> getAudioDevice() async {
    try {
      final output = await FlutterAudioOutput.getCurrentOutput();

      switch (output.port) {
        case AudioPort.bluetooth:
          debugPrint("Bluetooth (${output.name})");
          return "Bluetooth (${output.name})";

        case AudioPort.headphones:
          debugPrint("Kabelgebundene Kopfhörer");
          return "Kabelgebundene Kopfhörer";

        case AudioPort.speaker:
          debugPrint("Lautsprecher");
          return "Lautsprecher";

        case AudioPort.receiver:
          debugPrint("Hörmuschel");
          return "Hörmuschel";

        default:
          return output.name;
      }
    } catch (e, stackTrace) {
      debugPrint("AudioDevice Error: $e");
      debugPrint(stackTrace.toString());
      return "Unknown";
    }
  }
}
