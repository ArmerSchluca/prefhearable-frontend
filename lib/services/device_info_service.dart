import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/device_information.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_audio_output/flutter_audio_output.dart';

/// Ermittelt Informationen über das verwendete Endgerät.
///
/// Der Service bündelt den Zugriff auf gerätespezifische Informationen,
/// die im Rahmen einer Umfrage zusammen mit den erhobenen Daten gespeichert
/// werden.
class DeviceInformationService {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  /// Erfasst sämtliche für die Umfrage relevanten Geräteinformationen.
  static Future<DeviceInformation> getDeviceInformation() async {
    return DeviceInformation(
      appVersion: await getAppVersion(),
      operatingSystem: await getOperatingSystem(),
      model: await getModel(),
    );
  }

  /// Liest die aktuelle Version der Anwendung aus (siehe pubspec.yaml "version").
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Ermittelt das Betriebssystem des verwendeten Geräts.
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

  /// Ermittelt die Gerätebezeichnung des verwendeten Endgeräts.
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

  /// Ermittelt das aktuell verwendete Audiowiedergabegerät.
  ///
  /// Die Information wird während des Hörtests erfasst, um die
  /// Wiedergabeumgebung der Bewertung nachvollziehen zu können.
  static Future<String> getAudioDevice() async {
    try {
      final output = await FlutterAudioOutput.getCurrentOutput();

      switch (output.port) {
        case AudioPort.bluetooth:
          return "Bluetooth (${output.name})";

        case AudioPort.headphones:
          return "Kabelgebundene Kopfhörer";

        case AudioPort.speaker:
          return "Lautsprecher";

        case AudioPort.receiver:
          return "Hörmuschel";

        default:
          return output.name;
      }
    } catch (e) {
      debugPrint("Audiogerät konnte nicht ermittelt werden: $e");
      return "Unknown";
    }
  }
}
