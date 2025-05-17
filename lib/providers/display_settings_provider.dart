import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingsProvider extends ChangeNotifier {
  // Default values
  bool _darkMode = true;
  double _brightness = 0.7;
  double _textSize = 1.0;
  bool _showTransactionIcons = true;

  // Getters
  bool get darkMode => _darkMode;
  double get brightness => _brightness;
  double get textSize => _textSize;
  bool get showTransactionIcons => _showTransactionIcons;

  // Define the gold color
  final Color goldColor = const Color.fromARGB(255, 193, 154, 107);

  // Constructor - load saved settings
  DisplaySettingsProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('darkMode') ?? true;
    _brightness = prefs.getDouble('brightness') ?? 0.7;
    _textSize = prefs.getDouble('textSize') ?? 1.0;
    _showTransactionIcons = prefs.getBool('showTransactionIcons') ?? true;
    
    // Apply settings immediately on load
    _applyBrightness();
    notifyListeners();
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setDouble('brightness', _brightness);
    await prefs.setDouble('textSize', _textSize);
    await prefs.setBool('showTransactionIcons', _showTransactionIcons);
    
    // Apply settings when saved
    _applyBrightness();
    notifyListeners();
  }

  // Update individual settings
  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setBrightness(double value) {
    _brightness = value;
    _applyBrightness();
    notifyListeners();
  }

  void setTextSize(double value) {
    _textSize = value;
    notifyListeners();
  }

  void setShowTransactionIcons(bool value) {
    _showTransactionIcons = value;
    notifyListeners();
  }
  
  // Apply brightness setting to system
  void _applyBrightness() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
    );
    
    // For full brightness control, you would use the screen_brightness package
    // Example if screen_brightness package is added:
    // 
    // try {
    //   ScreenBrightness().setScreenBrightness(_brightness);
    // } catch (e) {
    //   print('Failed to set brightness: $e');
    // }
  }
  
  // Get theme based on dark mode setting
  ThemeData getTheme() {
    return _darkMode 
      ? ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: goldColor,
            brightness: Brightness.dark,
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: goldColor,
            thumbColor: goldColor,
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected) 
                  ? goldColor 
                  : null;
            }),
            trackColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected)
                  ? goldColor.withOpacity(0.5)
                  : null;
            }),
          ),
        )
      : ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: goldColor,
            brightness: Brightness.light,
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: goldColor,
            thumbColor: goldColor,
          ),
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected) 
                  ? goldColor 
                  : null;
            }),
            trackColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected)
                  ? goldColor.withOpacity(0.5)
                  : null;
            }),
          ),
        );
  }
  
  // Get text scale based on text size setting
  double getTextScaleFactor() {
    return _textSize;
  }
}