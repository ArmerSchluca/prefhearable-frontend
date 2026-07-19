import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/shared/input_styles.dart';

class AppDialog {
  static Future<void> showServerError(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 64, color: Colors.red.shade300),

              SizedBox(height: 16),

              Text(
                "Server nicht erreichbar",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              Text(
                "Die Verbindung zum Server konnte nicht hergestellt werden.\n\n"
                "Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showSelection(
    BuildContext context,
    Text title,
    Text content,
    Color? colorYes,
    Color? colorNo,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Nein',
                style: TextStyle(
                  color: colorNo ?? Colors.blueAccent,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Ja',
                style: TextStyle(color: colorYes ?? Colors.red, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showInfo(BuildContext context, Text title, Text content) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(10), child: content),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Schließen',
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showUuidConfirmation(
    BuildContext context,
    String correctUuid,
    String title,
    String message,
  ) async {
    final controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: AppInputStyles.textField(
                  label: "Teilnahme-ID",
                  hint: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                  accentColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Abbrechen",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                final input = controller.text.trim();

                if (input == correctUuid) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Teilnahme-ID falsch!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pop(context, false);
                }
              },
              child: Text(
                "Bestätigen",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> showNoiseCountdown(BuildContext context) async {
    int seconds = 3;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            Timer? timer;

            return StatefulBuilder(
              builder: (context, setState) {
                timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
                  if (seconds == 1) {
                    t.cancel();
                    Navigator.pop(context, true);
                  } else {
                    setState(() {
                      seconds--;
                    });
                  }
                });

                return AlertDialog(
                  title: const Text("Umgebungslautstärke"),
                  content: Text(
                    "Die Dezibelmessung beginnt in $seconds Sekunden.\n\n"
                    "Bitte halten Sie das Gerät ruhig und vermeiden Sie Gespräche.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        timer?.cancel();
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Abbrechen",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
  }

  static Future<void> showLoadingIndicator(
    BuildContext context,
    Color? color,
    String? message,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: color ?? Colors.blueAccent),
              SizedBox(height: 20),
              Text(message ?? "Bitte warten...", textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
