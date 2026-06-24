import 'package:flutter/material.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/view/home_view.dart';
import 'package:frontend/view/launch_view.dart';

class StartpageHelper extends StatefulWidget {
  const StartpageHelper({super.key});

  @override
  State<StartpageHelper> createState() => _StartpageHelpereState();
}

class _StartpageHelpereState extends State<StartpageHelper> {
  final SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final id = await _sessionService.getCurrentParticipantId();

    if (!mounted) return;

    if (id != null) {
      try {
        // Prüfe im Backend, ob UUID im Local Storage noch im existiert
        await _sessionService.loginWithUuid(id);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
        return;
      } catch (_) {
        await _sessionService.logoutParticipant();
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LaunchView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
