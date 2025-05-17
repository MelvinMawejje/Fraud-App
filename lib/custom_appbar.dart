import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final List<Widget>? actions; // Make actions optional

  const CustomAppbar({
    super.key,
    required this.heading,
    this.actions, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(heading,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      toolbarHeight: 50,
      backgroundColor: const Color.fromARGB(255, 193, 154, 107),
      actions: actions, // Pass the actions to AppBar
    );
  }

  // Add this to satisfy PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(50); // Match your toolbarHeight
}