import 'package:flutter/material.dart';

class ServerErrorView extends StatelessWidget {
  const ServerErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          // Server Connectivity Check
          "Server nicht erreichbar. Bitte stelle eine Internetverbindung her.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
