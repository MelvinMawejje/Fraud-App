import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class DisplaySettings extends StatefulWidget {
  const DisplaySettings({super.key});

  @override
  State<DisplaySettings> createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettings> {
  // Settings state variables
  bool _darkMode = true;
  double _brightness = 0.7;
  double _textSize = 1.0;
  bool _showTransactionIcons = true;
  
  // Define the gold color
  final goldColor = const Color.fromARGB(255, 193, 154, 107);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'DISPLAY',
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Dark Mode Switch
              _buildSettingCard(
                title: 'Dark Mode',
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enable Dark Mode'),
                    Switch(
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                      },
                      activeColor: goldColor,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Brightness Slider
              _buildSettingCard(
                title: 'Brightness',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Adjust screen brightness'),
                    Slider(
                      value: _brightness,
                      onChanged: (value) {
                        setState(() {
                          _brightness = value;
                        });
                      },
                      activeColor: goldColor,
                      min: 0.0,
                      max: 1.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Low'),
                        Text('${(_brightness * 100).toInt()}%'),
                        const Text('High'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Text Size
              _buildSettingCard(
                title: 'Text Size',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Adjust text size'),
                    Slider(
                      value: _textSize,
                      onChanged: (value) {
                        setState(() {
                          _textSize = value;
                        });
                      },
                      activeColor: goldColor,
                      min: 0.5,
                      max: 1.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Small'),
                        Text('${(_textSize * 100).toInt()}%'),
                        const Text('Large'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Show Transaction Icons
              _buildSettingCard(
                title: 'Transaction Icons',
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Show transaction icons'),
                    Switch(
                      value: _showTransactionIcons,
                      onChanged: (value) {
                        setState(() {
                          _showTransactionIcons = value;
                        });
                      },
                      activeColor: goldColor,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Display settings updated'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'APPLY CHANGES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to build settings card
  Widget _buildSettingCard({
    required String title,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}