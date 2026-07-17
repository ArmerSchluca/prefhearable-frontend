import 'package:flutter/material.dart';

class SaveAndContinueButton extends StatelessWidget {
  final Future<void> Function() onPressed;
  final Color color;

  const SaveAndContinueButton({
    super.key,
    required this.onPressed,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FilledButton.icon(
        onPressed: () async => await onPressed(),
        label: Text("Weiter", style: TextStyle(fontSize: 20)),
        icon: Icon(Icons.arrow_forward),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
