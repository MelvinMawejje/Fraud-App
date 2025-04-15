import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // Settings state variables
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _transactionAlerts = true;
  bool _securityAlerts = true;
  bool _promotionalAlerts = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  bool _quietHoursEnabled = false;
  
  // Define the gold color
  final goldColor = const Color.fromARGB(255, 193, 154, 107);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'NOTIFICATIONS',
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Notification Types
              _buildSettingCard(
                title: 'Notification Channels',
                content: Column(
                  children: [
                    _buildSwitchRow(
                      'Push Notifications', 
                      _pushNotifications,
                      (value) => setState(() => _pushNotifications = value),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchRow(
                      'Email Notifications', 
                      _emailNotifications,
                      (value) => setState(() => _emailNotifications = value),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchRow(
                      'SMS Notifications', 
                      _smsNotifications,
                      (value) => setState(() => _smsNotifications = value),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Alert Types
              _buildSettingCard(
                title: 'Alert Types',
                content: Column(
                  children: [
                    _buildSwitchRow(
                      'Transaction Alerts', 
                      _transactionAlerts,
                      (value) => setState(() => _transactionAlerts = value),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchRow(
                      'Security Alerts', 
                      _securityAlerts,
                      (value) => setState(() => _securityAlerts = value),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchRow(
                      'Promotional Alerts', 
                      _promotionalAlerts,
                      (value) => setState(() => _promotionalAlerts = value),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Quiet Hours
              _buildSettingCard(
                title: 'Quiet Hours',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSwitchRow(
                      'Enable Quiet Hours', 
                      _quietHoursEnabled,
                      (value) => setState(() => _quietHoursEnabled = value),
                    ),
                    const SizedBox(height: 16),
                    const Text('During quiet hours, you will not receive notifications'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Start Time:'),
                        TextButton(
                          onPressed: _quietHoursEnabled ? () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _quietHoursStart,
                            );
                            if (picked != null) {
                              setState(() {
                                _quietHoursStart = picked;
                              });
                            }
                          } : null,
                          child: Text(
                            '${_quietHoursStart.hour}:${_quietHoursStart.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: _quietHoursEnabled ? goldColor : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('End Time:'),
                        TextButton(
                          onPressed: _quietHoursEnabled ? () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _quietHoursEnd,
                            );
                            if (picked != null) {
                              setState(() {
                                _quietHoursEnd = picked;
                              });
                            }
                          } : null,
                          child: Text(
                            '${_quietHoursEnd.hour}:${_quietHoursEnd.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: _quietHoursEnabled ? goldColor : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification settings updated'),
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
                    'SAVE SETTINGS',
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
  
  // Helper method for switch rows
  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: goldColor,
        ),
      ],
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