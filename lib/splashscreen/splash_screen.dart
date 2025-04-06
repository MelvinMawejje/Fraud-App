import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically navigate to home screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/HomeScreen()');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define your gold color that matches the image
    final goldColor = const Color.fromARGB(255, 193, 154, 107);
    final darkBackground = Colors.black;
    
    return Scaffold(
      body: Column(
        children: [
          // Top half - Gold with "FRAUD"
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: goldColor,
              child: const Center(
                child: Text(
                  'FRAUD',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom half - Black with "WATCH"
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: darkBackground,
              child: Center(
                child: Text(
                  'WATCH',
                  style: TextStyle(
                    color: goldColor,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}