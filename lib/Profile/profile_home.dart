import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:fraud_watch/Profile/screens/user_screen.dart';
import 'package:fraud_watch/Profile/screens/history_screen.dart';
import 'package:fraud_watch/Profile/screens/events_screen.dart';
import 'package:fraud_watch/Profile/screens/reports_screen.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({super.key});
  
  @override
  Widget build(BuildContext context) {
    final goldColor = const Color.fromARGB(255, 193, 154, 107);
    
    return BaseLayout(
      appBarTitle: 'PROFILE',
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildProfileButton(
                icon: Icons.person_outline,
                text: 'USER',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserScreen()),
                  );
                },
                goldColor: goldColor,
              ),
              const SizedBox(height: 16),
              _buildProfileButton(
                icon: Icons.history,
                text: 'HISTORY',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
                goldColor: goldColor,
              ),
              const SizedBox(height: 16),
              _buildProfileButton(
                icon: Icons.more_vert,
                text: 'EVENTS',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventsScreen()),
                  );
                },
                goldColor: goldColor,
              ),
              const SizedBox(height: 16),
              _buildProfileButton(
                icon: Icons.assignment_outlined,
                text: 'REPORTS',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportsScreen()),
                  );
                },
                goldColor: goldColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color goldColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: goldColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}