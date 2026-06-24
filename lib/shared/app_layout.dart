import 'package:flutter/material.dart';
import 'custom_appbar.dart';

class AppLayout extends StatelessWidget {
  final CustomAppBar? appBar;
  final List<Widget> children;

  const AppLayout({
    super.key,
    this.appBar,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar ?? const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}