import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final goldColor = const Color.fromARGB(255, 193, 154, 107);
  String _selectedPeriod = 'Last 30 Days';
  final List<String> _periods = ['Last 7 Days', 'Last 30 Days', 'Last 90 Days', 'Last Year'];

  // Sample data for reports - this would connect to your ML model in production
  final Map<String, dynamic> _reportData = {
    'alertsTriggered': 24,
    'highRiskAlerts': 3,
    'mediumRiskAlerts': 7,
    'lowRiskAlerts': 14,
    'resolvedAlerts': 21,
    'pendingAlerts': 3,
    'riskScore': 82,
    'accountSecurity': 95,
    'suspiciousActivities': [
      {
        'date': 'Apr 2, 2025',
        'activity': 'Login attempt from unknown location',
        'risk': 'High',
      },
      {
        'date': 'Mar 30, 2025',
        'activity': 'Multiple failed login attempts',
        'risk': 'Medium',
      },
      {
        'date': 'Mar 28, 2025',
        'activity': 'Large transaction flagged',
        'risk': 'Medium',
      },
    ],
    'monthlyStats': [
      {'month': 'Nov', 'alerts': 15},
      {'month': 'Dec', 'alerts': 21},
      {'month': 'Jan', 'alerts': 18},
      {'month': 'Feb', 'alerts': 24},
      {'month': 'Mar', 'alerts': 22},
      {'month': 'Apr', 'alerts': 24},
    ],
  };

  // ML prediction function - placeholder for your actual ML integration
  Future<Map<String, dynamic>> _getPredictions() async {
    // This would call your ML model API or local model
    // For now, returning sample data
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return {
      'fraudProbability': 0.15,
      'riskTrend': 'decreasing',
      'nextMonthPrediction': 18,
      'recommendedActions': [
        'Enable two-factor authentication',
        'Review recent large transactions',
        'Update security preferences'
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'REPORTS',
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 20),
              _buildSecurityScoreCard(),
              const SizedBox(height: 20),
              _buildAlertSummaryCard(),
              const SizedBox(height: 20),
              _buildRecentActivityCard(),
              const SizedBox(height: 20),
              _buildMlInsightsCard(),
              const SizedBox(height: 20),
              _buildActionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goldColor.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          icon: Icon(Icons.arrow_drop_down, color: goldColor),
          iconSize: 24,
          elevation: 16,
          isDense: true,
          isExpanded: true,
          dropdownColor: Colors.black,
          style: TextStyle(color: goldColor, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedPeriod = newValue;
                // In a real app, this would trigger data refresh based on period
                _refreshData(newValue);
              });
            }
          },
          items: _periods.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Method to refresh data based on selected period
  void _refreshData(String period) {
    // This would call your backend or ML model with the new period
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshing data for $period...'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // For demo purposes, we're not actually changing the data
  }

  Widget _buildSecurityScoreCard() {
    return GestureDetector(
      onTap: () {
        _showScoreDetails(context);
      },
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: goldColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Security Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: goldColor,
                    ),
                  ),
                  Icon(Icons.info_outline, color: goldColor, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreIndicator(
                    'Risk Level',
                    _reportData['riskScore'],
                    Colors.green,
                    'Low',
                  ),
                  _buildScoreIndicator(
                    'Account Security',
                    _reportData['accountSecurity'],
                    goldColor,
                    'Excellent',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showScoreDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: goldColor),
          ),
          title: Text('Security Score Details', 
            style: TextStyle(color: goldColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Password Strength', 90, 'Strong'),
              _buildDetailItem('Two-Factor Auth', 100, 'Enabled'),
              _buildDetailItem('Device Trust', 85, 'Good'),
              _buildDetailItem('Transaction Patterns', 75, 'Normal'),
              _buildDetailItem('Login Locations', 80, 'Consistent'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: goldColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, int score, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              Text('$score', style: TextStyle(color: goldColor, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Text('($status)', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(
    String label,
    int score,
    Color color,
    String status,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/100',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSummaryCard() {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: goldColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alert Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAlertItem(
                  'Total',
                  _reportData['alertsTriggered'].toString(),
                  Icons.notification_important,
                  goldColor,
                ),
                _buildAlertItem(
                  'Resolved',
                  _reportData['resolvedAlerts'].toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildAlertItem(
                  'Pending',
                  _reportData['pendingAlerts'].toString(),
                  Icons.pending,
                  Colors.orange,
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 32),
            _buildRiskLevelItem('High Risk', _reportData['highRiskAlerts'], Colors.red),
            const SizedBox(height: 8),
            _buildRiskLevelItem('Medium Risk', _reportData['mediumRiskAlerts'], Colors.orange),
            const SizedBox(height: 8),
            _buildRiskLevelItem('Low Risk', _reportData['lowRiskAlerts'], Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildRiskLevelItem(String label, int count, Color color) {
    final total = _reportData['alertsTriggered'] as int;
    final percentage = (count / total * 100).round();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            Text(
              '$count ($percentage%)',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: count / total,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildRecentActivityCard() {
    final activities = _reportData['suspiciousActivities'] as List;
    
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: goldColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Suspicious Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to detailed activity view
                    _navigateToDetailView();
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: goldColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index] as Map<String, String>;
                Color riskColor;
                
                switch (activity['risk']) {
                  case 'High':
                    riskColor = Colors.red;
                    break;
                  case 'Medium':
                    riskColor = Colors.orange;
                    break;
                  default:
                    riskColor = Colors.green;
                }
                
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    activity['activity']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    activity['date']!,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity['risk']!,
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    _showActivityDetails(context, activity);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to detailed activity view
  void _navigateToDetailView() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Navigating to all activities...'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // Navigate to a detailed activity screen in your app
  }

  // Show activity details popup
  void _showActivityDetails(BuildContext context, Map<String, String> activity) {
    Color riskColor;
    switch (activity['risk']) {
      case 'High':
        riskColor = Colors.red;
        break;
      case 'Medium':
        riskColor = Colors.orange;
        break;
      default:
        riskColor = Colors.green;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: goldColor),
          ),
          title: Row(
            children: [
              Text(
                activity['activity']!,
                style: TextStyle(color: goldColor, fontSize: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activity['risk']!,
                  style: TextStyle(
                    color: riskColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Date & Time', activity['date']! + ' 14:32:18'),
              _buildDetailRow('Device', 'iPhone 14 Pro'),
              _buildDetailRow('Location', 'San Francisco, CA (Unusual)'),
              _buildDetailRow('IP Address', '198.51.100.42'),
              _buildDetailRow('User Agent', 'Safari Mobile / iOS 16.5'),
              _buildDetailRow('Action Taken', 'Auto-blocked'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Dismiss', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _markAsReviewed();
              },
              child: Text('Mark as Reviewed', style: TextStyle(color: goldColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Mark as reviewed method
  void _markAsReviewed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Activity marked as reviewed'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // In a real app, this would update your database
  }

  // ML Insights Card - This is where ML integration happens
  Widget _buildMlInsightsCard() {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: goldColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: goldColor),
                const SizedBox(width: 8),
                Text(
                  'AI Fraud Detection Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: _getPredictions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 193, 154, 107)),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error loading predictions: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (snapshot.hasData) {
                  final predictions = snapshot.data!;
                  final fraudProb = (predictions['fraudProbability'] as double) * 100;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fraud Probability',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Row(
                            children: [
                              Text(
                                '${fraudProb.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: fraudProb > 30 ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                predictions['riskTrend'] == 'decreasing' 
                                  ? Icons.arrow_downward 
                                  : Icons.arrow_upward,
                                color: predictions['riskTrend'] == 'decreasing' 
                                  ? Colors.green 
                                  : Colors.red,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Predicted Next Month Alerts: ${predictions['nextMonthPrediction']}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Recommended Actions:',
                        style: TextStyle(
                          color: goldColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(predictions['recommendedActions'] as List).map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_right, color: goldColor, size: 16),
                              const SizedBox(width: 4),
                              Text(action, style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  );
                } else {
                  return const Text(
                    'No predictions available',
                    style: TextStyle(color: Colors.grey),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: goldColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'Generate Full Report',
              Icons.description_outlined,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Generating full report...'),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Run ML Risk Assessment',
              Icons.smart_toy_outlined,
              () {
                _runMlAssessment();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: goldColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Method to run ML assessment
  void _runMlAssessment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: goldColor),
          ),
          title: Text(
            'Machine Learning Assessment',
            style: TextStyle(color: goldColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 193, 154, 107)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Running comprehensive fraud detection analysis...',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'This may take a few moments',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        );
      },
    );

    // Simulate ML processing
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      
      // Show results dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: goldColor),
            ),
            title: Row(
              children: [
                Icon(Icons.security, color: goldColor),
                const SizedBox(width: 8),
                Text(
                  'Risk Assessment Complete',
                  style: TextStyle(color: goldColor),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your account has been analyzed using our advanced machine learning model.',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                _buildResultItem('Overall Risk', 'Low', Colors.green),
                _buildResultItem('Unusual Patterns', 'None detected', Colors.green),
                _buildResultItem('Suspicious Transactions', '1 flagged for review', Colors.orange),
                _buildResultItem('Identity Score', '98/100', goldColor),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to detailed assessment screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}