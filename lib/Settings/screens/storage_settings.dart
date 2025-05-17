import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:fraud_watch/Settings/screens/voice_datascreen.dart';



class StorageSettings extends StatefulWidget {
  const StorageSettings({super.key});

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  // Settings state variables
  bool _autoBackup = true;
  String _backupFrequency = 'Weekly';
  bool _syncToCloud = true;
  final List<String> _backupOptions = ['Daily', 'Weekly', 'Monthly'];
  double _storageUsed = 245.0; // in MB
  final double _storageTotal = 500.0; // in MB
  bool _clearingCache = false;

  // Define the gold color
  final goldColor = const Color.fromARGB(255, 193, 154, 107);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'STORAGE',
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Storage Usage
              _buildSettingCard(
                title: 'Storage Usage',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: _storageUsed / _storageTotal,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_storageUsed.toStringAsFixed(1)} MB used of ${_storageTotal.toStringAsFixed(1)} MB',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _clearingCache ? null : () async {
                          setState(() {
                            _clearingCache = true;
                          });

                          // Simulate clearing cache
                          await Future.delayed(const Duration(seconds: 2));

                          setState(() {
                            _storageUsed = 45.0; // Reduced storage usage
                            _clearingCache = false;
                          });

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cache cleared successfully'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _clearingCache
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('CLEARING CACHE...'),
                                ],
                              )
                            : const Text('CLEAR CACHE'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Backup Settings
              _buildSettingCard(
                title: 'Backup Settings',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSwitchRow(
                      'Auto Backup',
                      _autoBackup,
                      (value) => setState(() => _autoBackup = value),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Backup Frequency'),
                        DropdownButton<String>(
                          value: _backupFrequency,
                          onChanged: _autoBackup
                              ? (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _backupFrequency = newValue;
                                    });
                                  }
                                }
                              : null,
                          items: _backupOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          icon: Icon(Icons.arrow_drop_down, color: goldColor),
                          underline: Container(
                            height: 2,
                            color: goldColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSwitchRow(
                      'Sync to Cloud',
                      _syncToCloud,
                      (value) => setState(() => _syncToCloud = value),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Data Management
              _buildSettingCard(
                title: 'Data Management',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text('Export All Data'),
                      leading: Icon(Icons.file_download_outlined, color: goldColor),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Exporting data...'),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    ListTile( // Added Voice Data section
                      title: const Text('Voice Data'),
                      leading: Icon(Icons.mic_none_outlined, color: goldColor),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          // Provide the required audioPath argument.
                          // Adjust the value ('') if a specific path is needed here.
                          MaterialPageRoute(builder: (context) => const VoiceDataScreen()),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Delete All Data'),
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      onTap: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      contentPadding: EdgeInsets.zero,
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
                        content: Text('Storage settings updated'),
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

  // Helper method for delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Data'),
          content: const Text(
            'Are you sure you want to delete all your data? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: TextStyle(color: goldColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logic to delete data here
                setState(() {
                  // Potentially reset storage used if data deletion affects it
                  _storageUsed = 45.0; // Example reset
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data deleted'),
                  ),
                );
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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