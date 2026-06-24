import 'package:flutter/material.dart';

/// AppBar mit Defaults und optionalen Parametern. 
/// Defaults: schwarzer Hintergunrd, weiße Schrift, Text="Prefhearable", kein Navigationpfeil
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? color;
  final bool? nav;

  const CustomAppBar({
    super.key,
    this.title,
    this.color,
    this.nav,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Colors.black,
      automaticallyImplyLeading: false,
      leading: color == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title ?? "Prefhearable",
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }
}
