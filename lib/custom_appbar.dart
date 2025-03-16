import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;

  const CustomAppbar({
    super.key,
    required this.heading,
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
    );
  }

  // Add this to satisfy PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(50); // Match your toolbarHeight
}