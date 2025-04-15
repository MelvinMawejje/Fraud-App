import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final goldColor = const Color.fromARGB(255, 193, 154, 107);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'EVENTS',
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: goldColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: goldColor,
            tabs: const [
              Tab(text: 'UPCOMING'),
              Tab(text: 'REGISTERED'),
              Tab(text: 'PAST'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingEventsTab(),
                _buildRegisteredEventsTab(),
                _buildPastEventsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsTab() {
    // Sample upcoming events data
    final upcomingEvents = [
      {
        'title': 'Cybersecurity Awareness Workshop',
        'date': 'April 15, 2025',
        'time': '10:00 AM - 12:00 PM',
        'location': 'Virtual Event',
        'description': 'Learn about the latest cybersecurity threats and how to protect yourself from fraud and identity theft.',
        'imageAsset': 'assets/event1.jpg', // This would be replaced with an actual asset
      },
      {
        'title': 'Financial Fraud Prevention Seminar',
        'date': 'April 22, 2025',
        'time': '2:00 PM - 4:00 PM',
        'location': 'Tech Hub Conference Center',
        'description': 'Expert speakers will discuss common financial scams and strategies to prevent them.',
        'imageAsset': 'assets/event2.jpg', // This would be replaced with an actual asset
      },
      {
        'title': 'Digital Security in the Age of AI',
        'date': 'May 10, 2025',
        'time': '1:00 PM - 3:30 PM',
        'location': 'Downtown Innovation Space',
        'description': 'Panel discussion on how artificial intelligence is changing the landscape of digital security and fraud prevention.',
        'imageAsset': 'assets/event3.jpg', // This would be replaced with an actual asset
      },
    ];

    return _buildEventsList(upcomingEvents, true);
  }

  Widget _buildRegisteredEventsTab() {
    // Sample registered events data
    final registeredEvents = [
      {
        'title': 'Financial Fraud Prevention Seminar',
        'date': 'April 22, 2025',
        'time': '2:00 PM - 4:00 PM',
        'location': 'Tech Hub Conference Center',
        'description': 'Expert speakers will discuss common financial scams and strategies to prevent them.',
        'imageAsset': 'assets/event2.jpg', // This would be replaced with an actual asset
      },
    ];

    return _buildEventsList(registeredEvents, false);
  }

  Widget _buildPastEventsTab() {
    // Sample past events data
    final pastEvents = [
      {
        'title': 'Identity Protection Workshop',
        'date': 'March 15, 2025',
        'time': '1:00 PM - 3:00 PM',
        'location': 'Virtual Event',
        'description': 'This workshop covered strategies to protect your personal information and prevent identity theft.',
        'imageAsset': 'assets/event4.jpg', // This would be replaced with an actual asset
      },
      {
        'title': 'Banking Security Conference',
        'date': 'February 28, 2025',
        'time': '9:00 AM - 5:00 PM',
        'location': 'Financial Center Hall',
        'description': 'A full-day conference dedicated to security in banking and financial transactions.',
        'imageAsset': 'assets/event5.jpg', // This would be replaced with an actual asset
      },
    ];

    return _buildEventsList(pastEvents, false);
  }

  Widget _buildEventsList(List<Map<String, String>> events, bool canRegister) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: goldColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'No events found',
              style: TextStyle(
                fontSize: 18,
                color: goldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event, canRegister);
      },
    );
  }

  Widget _buildEventCard(Map<String, String> event, bool canRegister) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: goldColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This would be replaced with an actual image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.event,
                size: 64,
                color: goldColor.withOpacity(0.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildEventDetailRow(Icons.calendar_today, event['date']!),
                _buildEventDetailRow(Icons.access_time, event['time']!),
                _buildEventDetailRow(Icons.location_on, event['location']!),
                const SizedBox(height: 12),
                Text(
                  event['description']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 16),
                if (canRegister)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showRegistrationDialog(event);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                if (!canRegister && _tabController.index == 1)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show cancel registration dialog
                        _showCancelRegistrationDialog(event);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: goldColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: goldColor, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'CANCEL REGISTRATION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: goldColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  void _showRegistrationDialog(Map<String, String> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Register for Event', style: TextStyle(color: goldColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${event['date']}',
              style: TextStyle(color: Colors.grey[300]),
            ),
            Text(
              'Time: ${event['time']}',
              style: TextStyle(color: Colors.grey[300]),
            ),
            Text(
              'Location: ${event['location']}',
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Would you like to register for this event? You will receive a confirmation email with additional details.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: TextStyle(color: goldColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              // Add event to registered events
              setState(() {
                _tabController.animateTo(1); // Switch to registered tab
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Successfully registered for event'),
                ),
              );
            },
            child: const Text('REGISTER'),
          ),
        ],
      ),
    );
  }

  void _showCancelRegistrationDialog(Map<String, String> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Cancel Registration', style: TextStyle(color: goldColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel your registration for:',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              event['title']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${event['date']}',
              style: TextStyle(color: Colors.grey[300]),
            ),
            Text(
              'Time: ${event['time']}',
              style: TextStyle(color: Colors.grey[300]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('KEEP REGISTRATION', style: TextStyle(color: goldColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Remove event from registered events
              setState(() {
                _tabController.animateTo(0); // Switch to upcoming tab
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration canceled'),
                ),
              );
            },
            child: const Text('CANCEL REGISTRATION'),
          ),
        ],
      ),
    );
  }
}