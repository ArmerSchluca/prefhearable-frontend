import 'package:flutter/material.dart';
import 'package:frontend/shared_components/app_layout.dart';
import 'package:frontend/shared_components/custom_appbar.dart';

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
        // Age
        SizedBox(height: 12), 
        
        SizedBox(height: 12)],
    );
  }
}
