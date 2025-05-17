import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_navbar.dart';

class BaseLayout extends StatelessWidget {
  final String appBarTitle; 
  final Widget body;
  final List<Widget>? actions;

  const BaseLayout({
    super.key,
    required this.appBarTitle, // Required title for the appbar
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(heading: appBarTitle, 
      actions: actions, // Pass actions to the appbar
      ), 
      body: body,
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}