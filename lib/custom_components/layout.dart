import 'package:flutter/material.dart';
import 'package:frontend/custom_components/footer.dart';
import 'appbar.dart';

class AppLayout extends StatelessWidget {
  final CustomAppBar? appBar;
  final List<Widget> children;
  final AppFooter? footer;

  const AppLayout({
    super.key,
    this.appBar,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: footer,
    );
  }
}
