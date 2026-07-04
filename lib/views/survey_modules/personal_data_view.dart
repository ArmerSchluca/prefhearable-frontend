import 'package:flutter/material.dart';
import 'package:frontend/custom_components/dialogs.dart';
import 'package:frontend/custom_components/layout.dart';
import 'package:frontend/custom_components/appbar.dart';
import 'package:frontend/custom_components/footer.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      footer: AppFooter(
        actions: [
          TextButton.icon(
            icon: Icon(Icons.info, size: 20, color: Colors.blueGrey),
            label: Text(
              "Info",
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
            onPressed: () {
              AppDialog.showInfo(
                context,
                Text("Titel"),
                Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "
                  "sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                ),
              );
            },
          ),
        ],
      ),
      appBar: CustomAppBar(
        title: "Personendaten",
        color: Colors.orange,
        nav: true,
      ),
      children: [SizedBox(height: 12), SizedBox(height: 12)],
    );
  }
}
