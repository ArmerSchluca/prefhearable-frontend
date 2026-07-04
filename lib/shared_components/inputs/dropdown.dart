import 'package:flutter/material.dart';
import 'package:frontend/shared/input_styles.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final Color accentColor;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.accentColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: AppInputs.dropdown(
        accentColor: accentColor,
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}