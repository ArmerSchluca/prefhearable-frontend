import 'package:flutter/material.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/view/home_view.dart';
import 'package:frontend/view/launch_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final SessionService _sessionService = SessionService();

  String _participantId = '';
  String? _errorMessage;

  Future<void> _login() async {
    try {
      await _sessionService.loginWithUuid(_participantId.trim());

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    } catch (_) {
      setState(() {
        _errorMessage = "UUID nicht gefunden";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      children: [
        Center(child: const Icon(Icons.fingerprint, size: 150)),

        const SizedBox(height: 30),

        TextField(
          onChanged: (value) {
            _participantId = value;
            _errorMessage = null;
          },
          decoration: InputDecoration(
            labelText: "UUID",
            hintText: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",

            floatingLabelStyle: const TextStyle(color: Colors.blueAccent),

            border: const OutlineInputBorder(),

            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),

            errorText: _errorMessage,
          ),
        ),

        const SizedBox(height: 50),

        SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            onPressed: _login,
            child: const Text(
              "Mit UUID anmelden",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),

        const SizedBox(height: 30),

        Center(child: const Text("oder")),

        const SizedBox(height: 30),

        Center(
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LaunchView()),
              );
            },
            child: const Text("zurück zum anmeldefreien Start"),
          ),
        ),
      ],
    );
  }
}
