import 'package:flutter/material.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/shared/custom_appbar.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Personendaten",
        color: Colors.orange,
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
