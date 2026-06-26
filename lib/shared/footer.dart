import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final List<Widget> actions;

  const AppFooter({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions,
      ),
    );
  }
}
