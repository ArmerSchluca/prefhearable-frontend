import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // Konstruktor
  const HomePage({super.key});

  // Jedes Widget(=HomePage-Class) hat eine build-Methode, die den View-Tree baut
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Survey App", style: TextStyle(color: Colors.amberAccent)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Text("Personal Data"),
          Text("Context Data"),
          Text("Audio Tests"),
          Text("Questionnaires"),
        ],
      ),
    );
  }
}
