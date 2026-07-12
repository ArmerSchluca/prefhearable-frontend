import 'package:flutter/material.dart';
import 'package:frontend/utils/launch_handler.dart';

/// Einstiegspunkt der Flutter-Anwendung
void main() {
  runApp(const Main());
}

/// Root-Widget der Anwendung
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LaunchHandler(),
    );
  }
}
