import 'package:flutter/material.dart';
import 'package:frontend/view/home_view.dart';
import 'package:frontend/service/session_service.dart';
import 'package:frontend/view/launch_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _uuidController = TextEditingController();
  final SessionService _participantService = SessionService();

  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Prefhearable", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.fingerprint, size: 150)),

            SizedBox(height: 30.0),

            TextField(
              controller: _uuidController,
              decoration: InputDecoration(
                labelText: "UUID eingeben",
                hintText: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
            ),

            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    _isLoading ? Colors.grey : Colors.blue,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Mit UUID anmelden',
                        style: TextStyle(fontSize: 20.0),
                      ),
              ),
            ),
            SizedBox(height: 30),
            Center(child: Text("oder", style: TextStyle(fontSize: 16.0))),
            SizedBox(height: 30),
            Center(
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LaunchView()),
                  );
                },
                child: Text(
                  'zurück zum anmeldefreien Start',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _participantService.loginWithUuid(_uuidController.text.trim());

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    } catch (e) {
      setState(() {
        _error = "Login fehlgeschlagen";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _uuidController.dispose();
    super.dispose();
  }
}
