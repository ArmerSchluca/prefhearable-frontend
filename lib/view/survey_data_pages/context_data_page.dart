import 'package:flutter/material.dart';
import 'package:frontend/util/custom_appbar.dart';

class ContextDataView extends StatelessWidget {
  const ContextDataView({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Kontextdaten", backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text("Lorem Ipsum"),
            SizedBox(height: 12),
            Text("Lorem Ipsum"),
            SizedBox(height: 12),
            Text("Lorem Ipsum"),
            SizedBox(height: 12),
            Text("Lorem Ipsum"),
          ],
        ),
      ),
    );
  }
}