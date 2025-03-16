import 'package:flutter/material.dart';
import 'package:fraud_watch/Profile/profile_home.dart';
import 'package:fraud_watch/Settings/settings_home.dart';
import 'package:fraud_watch/home_screen.dart';
import 'package:fraud_watch/text_screen.dart';
import 'package:fraud_watch/voice_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Lato',
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor:Color.fromARGB(255, 193, 154, 107),,
        //   brightness: Brightness.dark,
        // ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
          seedColor:Color.fromARGB(255, 193, 154, 107),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // Explicitly set system theme mode
      debugShowCheckedModeBanner: false,
      routes: {
        '/voice_screen': (context) => const VoiceScreen(),
        '/text_screen': (context) => const TextScreen(),
        '/profile': (context) => const ProfileHome(),
        '/settings': (context) => const SettingsHome(),
        '/home': (context) => const HomeScreen(),
      },
    );
}
}