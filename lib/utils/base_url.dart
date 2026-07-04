import 'dart:io';

String get baseUrl {
  if (Platform.isAndroid) {
    return "http://10.0.2.2:3000";
  }
  // Windows / macOS / Linux / iOS / Browser
  return "http://localhost:3000";
}
