import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_navbar.dart';

class BaseLayout extends StatelessWidget {
  final String appBarTitle; 
  final Widget body;

  const BaseLayout({
    super.key,
    required this.appBarTitle, // Required title for the appbar
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(heading: appBarTitle), // Pass the title here
      body: body,
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}