import 'package:flutter/material.dart';
import 'package:frontend/shared_components/inputs.dart';

class AppDialog {
  static Future<void> showServerError(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Server nicht erreichbar"),
          content: Text(
            "Die Verbindung zum Server konnte nicht hergestellt werden. "
            "Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Ja',
                style: TextStyle(color: Colors.red, fontSize: 18),
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
                decoration: AppInputs.textField(
                  label: "Zugangscode",
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
                      content: Text("Zugangscode falsch!"),
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
}
