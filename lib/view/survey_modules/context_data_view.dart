import 'package:flutter/material.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/shared/custom_appbar.dart';

class ContextDataView extends StatelessWidget {
  const ContextDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Kontextdaten",
        color: Colors.green,
        nav: true,
      ),
      children: [
        Text("Lorem Ipsum"),
        SizedBox(height: 12),
        Text("Lorem Ipsum"),
        SizedBox(height: 12),
        Text("Lorem Ipsum"),
        SizedBox(height: 12),
        Text("Lorem Ipsum"),
      ],
    );
  }
}
