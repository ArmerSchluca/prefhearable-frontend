import 'package:flutter/material.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/launch_view.dart';
import 'package:frontend/utils/base_url.dart';
import 'package:http/http.dart' as http;

class LaunchHelper extends StatefulWidget {
  const LaunchHelper({super.key});

  @override
  State<LaunchHelper> createState() => _LaunchHelperState();
}

class _LaunchHelperState extends State<LaunchHelper> {
  @override
  void initState() {
    super.initState();
    _checkServerConnection();
    _checkSession();
  }

  Future<void> _checkSession() async {
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

  Future<void> _checkServerConnection() async {
    final response = await http.get(Uri.parse('$baseUrl/health'));

    if (response.statusCode != 200) {
      throw Exception("SERVER_CONNECTION_FAILED");
    }

    debugPrint('SERVER_CONNECTION_SUCCESSFUL');
  }
}
