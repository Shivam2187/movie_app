import 'package:flutter/material.dart';

AppBar buildAppBar({
  required BuildContext context,
  required String title,
  bool showBackButton = false,
  void Function(bool)? onChanged,
  bool showFavorites = false,
}) {
  return AppBar(
    toolbarHeight: 48,
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.blue,
    actions: [
      Switch(
        value: showFavorites,
        onChanged: onChanged,
        activeColor: Colors.red,
        inactiveThumbColor: Colors.white,
      )
    ],
    leading: IconButton(
      onPressed: () {},
      icon: const Icon(Icons.menu, color: Colors.white),
    ),
  );
}
