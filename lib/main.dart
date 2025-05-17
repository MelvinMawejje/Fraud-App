import 'package:flutter/material.dart';
import 'package:fraud_watch/Profile/profile_home.dart';
import 'package:fraud_watch/Settings/settings_home.dart';
import 'package:fraud_watch/home_screen.dart';
import 'package:fraud_watch/text_screen.dart';
import 'package:fraud_watch/voice_screen.dart';
import 'package:fraud_watch/splashscreen/splash_screen.dart';
import 'package:fraud_watch/Settings/screens/display_settings.dart';
import 'package:fraud_watch/Settings/screens/notification_settings.dart';
import 'package:fraud_watch/Settings/screens/storage_settings.dart';
import 'package:fraud_watch/Settings/screens/contact_us.dart';
import 'package:fraud_watch/Profile/screens/history_screen.dart';
import 'package:fraud_watch/Profile/screens/user_screen.dart';
import 'package:fraud_watch/Profile/screens/events_screen.dart';
import 'package:fraud_watch/Profile/screens/reports_screen.dart';
import 'package:fraud_watch/Profile/screens/reports_screendata.dart';

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
        '/splash_screen': (context) => const SplashScreen(),
        '/splash': (context) => const SplashScreen(),
        '/display_settings': (context) => const DisplaySettings(),
        '/notification_settings': (context) => const NotificationSettings(),
        '/storage_settings': (context) => const StorageSettings(),
        '/contact_us': (context) => const ContactUs(),
        '/user_screen': (context) => const UserScreen(),
        '/history_screen': (context) => const HistoryScreen(),
        '/events_screen': (context) => const EventsScreen(),
        '/reports_screen': (context) => const ReportsScreen(),
        '/reports': (context) => const ReportsDataScreen(),
      },
    );
}
}
