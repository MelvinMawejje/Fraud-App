import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goldColor = const Color.fromARGB(255, 193, 154, 107);
    
    // Sample history data - in a real app, this would come from a database or API
    final List<Map<String, dynamic>> historyItems = [
      {
        'date': 'Apr 3, 2025',
        'time': '14:32',
        'title': 'Suspicious Login Alert',
        'description': 'Unusual login detected from New York, USA',
        'status': 'Resolved',
        'icon': Icons.security,
      },
      {
        'date': 'Apr 2, 2025',
        'time': '09:17',
        'title': 'Transaction Monitor',
        'description': 'Large transaction flagged for review',
        'status': 'In Review',
        'icon': Icons.account_balance_wallet,
      },
      {
        'date': 'Mar 30, 2025',
        'time': '18:45',
        'title': 'Password Changed',
        'description': 'Your account password was updated',
        'status': 'Completed',
        'icon': Icons.lock,
      },
      {
        'date': 'Mar 28, 2025',
        'time': '11:20',
        'title': 'Phishing Attempt Blocked',
        'description': 'System detected and blocked a phishing attempt',
        'status': 'Blocked',
        'icon': Icons.block,
      },
      {
        'date': 'Mar 25, 2025',
        'time': '16:05',
        'title': 'Two-Factor Authentication',
        'description': 'Two-factor authentication enabled for your account',
        'status': 'Completed',
        'icon': Icons.phonelink_lock,
      },
    ];

    return BaseLayout(
      appBarTitle: 'HISTORY',
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  return _buildHistoryItem(
                    context,
                    date: item['date'],
                    time: item['time'],
                    title: item['title'],
                    description: item['description'],
                    status: item['status'],
                    icon: item['icon'],
                    goldColor: goldColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String date,
    required String time,
    required String title,
    required String description,
    required String status,
    required IconData icon,
    required Color goldColor,
  }) {
    Color statusColor;
    switch (status) {
      case 'Resolved':
        statusColor = Colors.green;
        break;
      case 'In Review':
        statusColor = Colors.orange;
        break;
      case 'Blocked':
        statusColor = Colors.red;
        break;
      case 'Completed':
        statusColor = goldColor;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      color: Colors.black,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: goldColor.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          _showHistoryItemDetails(
            context,
            date,
            time,
            title,
            description,
            status,
            goldColor,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: goldColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: goldColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: goldColor),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: goldColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, size: 14, color: goldColor),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: goldColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistoryItemDetails(
    BuildContext context,
    String date,
    String time,
    String title,
    String description,
    String status,
    Color goldColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(title, style: TextStyle(color: goldColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', date, goldColor),
            _buildDetailRow('Time', time, goldColor),
            _buildDetailRow('Status', status, goldColor),
            _buildDetailRow('Details', description, goldColor),
            const SizedBox(height: 16),
            const Text(
              'Taking proactive measures helps ensure your account remains secure. Our system continuously monitors for suspicious activities and alerts you to potential security threats.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color goldColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: goldColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}