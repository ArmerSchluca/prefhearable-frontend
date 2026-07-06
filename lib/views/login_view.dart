import 'package:flutter/material.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/utils/session_instance.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/launch_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String participantId = '';
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      children: [
        Center(child: Icon(Icons.fingerprint, size: 150)),

        SizedBox(height: 30),

        TextField(
          onChanged: (value) {
            participantId = value;
            errorMessage = null;
          },
          decoration: AppInputStyles.textField(
            label: "Zugangscode",
            hint: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            accentColor: Colors.blueAccent,
            errorText: errorMessage,
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
            onPressed: login,
            child: Text("Anmelden", style: TextStyle(fontSize: 20)),
          ),
        ),
        SizedBox(height: 30),
        Center(child: Text("oder", style: TextStyle(fontSize: 16))),
        SizedBox(height: 30),
        Center(
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LaunchView()),
              );
            },
            child: Text(
              "zurück zum anmeldefreien Start",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login() async {
    try {
      await session.loginWithUuid(participantId.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Anmeldung erfolgreich!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } catch (e) {
      if (!mounted) return;

      if (e.toString().contains('INVALID_UUID_FORMAT')) {
        setState(() {
          errorMessage = 'Ungültiger Zugangscode: falsches Format!';
        });
        return;
      }

      if (e.toString().contains('PARTICIPANT_NOT_FOUND')) {
        setState(() {
          errorMessage = 'Zugangscode nicht gefunden!';
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
}
