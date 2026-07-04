import 'package:flutter/material.dart';

class AppInputs {
  // TEXTFELD
  static InputDecoration textField({
    required String label,
    String? hint,
    Color accentColor = Colors.blue,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      floatingLabelStyle: TextStyle(color: accentColor),

      border: OutlineInputBorder(),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
      ),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),

      errorText: errorText,
    );
  }

  // DROPDOWN
  static InputDecoration dropdown({required Color accentColor}) {
    return InputDecoration(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
      ),
    );
  }
}
