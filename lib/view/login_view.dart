import 'package:flutter/material.dart';
import 'package:frontend/shared/app_dialogs.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/shared/inputs.dart';
import 'package:frontend/util/session.dart';
import 'package:frontend/view/home_view.dart';
import 'package:frontend/view/launch_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _participantId = '';
  String? _errorMessage;

  Future<void> _login() async {
    try {
      await session.loginWithUuid(_participantId.trim());

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    } catch (e) {
      if (!mounted) return;

      if (e.toString().contains('INVALID_UUID_FORMAT')) {
        setState(() {
          _errorMessage = 'Ungültiger Zugangscode: falsches Format!';
        });
        return;
      }

      if (e.toString().contains('PARTICIPANT_NOT_FOUND')) {
        setState(() {
          _errorMessage = 'Zugangscode nicht gefunden!';
        });
        return;
      }

      if (e.toString().contains('SERVER_UNREACHABLE')) {
        await AppDialog.showServerError(context);
        return;
      }

      await AppDialog.showServerError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      children: [
        Center(child: const Icon(Icons.fingerprint, size: 150)),

        SizedBox(height: 30),

        TextField(
          onChanged: (value) {
            _participantId = value;
            _errorMessage = null;
          },
          decoration: AppInputs.textField(
            label: "Zugangscode",
            hint: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            accentColor: Colors.blueAccent,
            errorText: _errorMessage,
          ),
        ),

        SizedBox(height: 50),

        SizedBox(
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: _login,
            child: const Text("Anmelden", style: TextStyle(fontSize: 20)),
          ),
        ),

        SizedBox(height: 30),

        Center(child: const Text("oder", style: TextStyle(fontSize: 16))),

        SizedBox(height: 30),

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
            child: const Text(
              "zurück zum anmeldefreien Start",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
