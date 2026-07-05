import 'package:flutter/material.dart';

/// AppBar mit Defaults und optionalen Parametern.
/// Defaults: schwarzer Hintergrund, weiße Schrift, Text="Prefhearable", kein Navigationpfeil
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? color;
  final bool? nav;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.color,
    this.nav,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Colors.black,
      automaticallyImplyLeading: false,
      leading: nav == true
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title ?? "Prefhearable",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }
}
