import 'package:flutter/material.dart';
import 'package:frontend/shared/input_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final Color accentColor;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.accentColor = Colors.blue,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: AppInputs.textField(
        label: label,
        hint: hint,
        accentColor: accentColor,
        errorText: errorText,
      ),
    );
  }
}