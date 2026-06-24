import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> showServerError(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Server nicht erreichbar"),
          content: const Text(
            "Die Verbindung zum Server konnte nicht hergestellt werden. "
            "Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.blueAccent),
              ),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
