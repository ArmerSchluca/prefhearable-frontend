import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final SectionStatus status;
  final VoidCallback onTap;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 5,
            right: 5,
            bottom: 15,
          ),
          child: ListTile(
            leading: icon,
            title: Text(title, style: TextStyle(fontSize: 18)),
            trailing: Icon(
              status == SectionStatus.complete
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: status == SectionStatus.complete
                  ? Colors.blue
                  : Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

enum SectionStatus { incomplete, complete }

extension StatusLabel on SectionStatus {
  String get label {
    switch (this) {
      case SectionStatus.incomplete:
        return "Offen";
      case SectionStatus.complete:
        return "Erfasst";
    }
  }
}