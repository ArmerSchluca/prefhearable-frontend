import 'package:flutter/material.dart';
import 'package:frontend/shared/app_layout.dart';
import 'package:frontend/view/survey_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      children: [
        // "Neue Umfrage starten" BUTTON
        SizedBox(
          width: double.infinity,
          height: 55,
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.blue),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // eckig
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SurveyView()),
              );
            },
            child: Text("Neue Umfrage starten"),
          ),
        ),
      ],
    );
  }
}
