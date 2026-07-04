import 'package:flutter/material.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/launch_view.dart';

class StartpageHelper extends StatefulWidget {
  const StartpageHelper({super.key});

  @override
  State<StartpageHelper> createState() => _StartpageHelpereState();
}

class _StartpageHelpereState extends State<StartpageHelper> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    final id = await session.getCurrentParticipantId();

    if (!mounted) return;

    if (id != null) {
      try {
        // Prüfe im Backend, ob UUID im Local Storage noch im existiert
        await session.loginWithUuid(id);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
        return;
      } catch (context) {
        await session.logoutParticipant();
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LaunchView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
