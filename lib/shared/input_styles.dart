import 'package:flutter/material.dart';

class AppInputStyles {
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
  static InputDecoration dropdown({
    required String label,
    String? hint,
    Color accentColor = Colors.blue,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      floatingLabelStyle: TextStyle(color: accentColor, fontSize: 22),

      border: OutlineInputBorder(),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
      ),

      errorText: errorText,
    );
  }
}
