import 'package:flutter/material.dart';
import 'package:frontend/util/custom_appbar.dart';

class AudioTestView extends StatelessWidget {
  const AudioTestView({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Hörtest", backgroundColor: Colors.pinkAccent),
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