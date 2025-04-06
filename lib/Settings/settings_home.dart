// import 'package:flutter/material.dart';
// import 'package:fraud_watch/baselayout.dart';

// class SettingsHome extends StatelessWidget {
//   const SettingsHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BaseLayout(appBarTitle: 'settings',
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Text('Welcome to your settings',
//              style: TextStyle(
//                fontSize: 20,
//              ),),
//            SizedBox(height: 20),
//            Text('You can view your settings here',
//              style: TextStyle(
//                fontSize: 20,
//              ),),
//          ],
//        ),
//      ),);
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:fraud_watch/baselayout.dart';

// class SettingsHome extends StatelessWidget {
//   const SettingsHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Define your gold color that matches the image
//     final goldColor = const Color.fromARGB(255, 193, 154, 107);
    
//     return BaseLayout(
//       // ===========================appbar=======================
//       appBarTitle: 'SETTINGS',
      
//       // ================== Body ==================
//       body: Center(
//         child: SafeArea(
//           minimum: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
              
//               // DISPLAY button
//               _buildSettingsButton(
//                 icon: Icons.monitor_outlined,
//                 text: 'DISPLAY',
//                 onPressed: () {
//                   // Navigate to display settings
//                   // Navigator.pushNamed(context, '/display_settings');
//                 },
//                 goldColor: goldColor,
//               ),
              
//               const SizedBox(height: 16),
              
//               // NOTIFICATIONS button
//               _buildSettingsButton(
//                 icon: Icons.notifications_outlined,
//                 text: 'NOTIFICATIONS',
//                 onPressed: () {
//                   // Navigate to notification settings
//                   // Navigator.pushNamed(context, '/notification_settings');
//                 },
//                 goldColor: goldColor,
//               ),
              
//               const SizedBox(height: 16),
              
//               // STORAGE button
//               _buildSettingsButton(
//                 icon: Icons.sd_card_outlined,
//                 text: 'STORAGE',
//                 onPressed: () {
//                   // Navigate to storage settings
//                   // Navigator.pushNamed(context, '/storage_settings');
//                 },
//                 goldColor: goldColor,
//               ),
              
//               const SizedBox(height: 16),
              
//               // CONTACT US button
//               _buildSettingsButton(
//                 icon: Icons.phone_outlined,
//                 text: 'CONTACT US',
//                 onPressed: () {
//                   // Navigate to contact page
//                   // Navigator.pushNamed(context, '/contact_us');
//                 },
//                 goldColor: goldColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   // Helper method to create consistent settings buttons
//   Widget _buildSettingsButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback onPressed,
//     required Color goldColor,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: goldColor,
//           foregroundColor: Colors.black,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 16),
//             Icon(icon, size: 24),
//             const SizedBox(width: 16),
//             Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:fraud_watch/Settings/screens/display_settings.dart';
import 'package:fraud_watch/Settings/screens/notification_settings.dart';
import 'package:fraud_watch/Settings/screens/storage_settings.dart';
import 'package:fraud_watch/Settings/screens/contact_us.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your gold color that matches the image
    final goldColor = const Color.fromARGB(255, 193, 154, 107);
    
    return BaseLayout(
      // ===========================appbar=======================
      appBarTitle: 'SETTINGS',
      
      // ================== Body ==================
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // DISPLAY button
              _buildSettingsButton(
                icon: Icons.monitor_outlined,
                text: 'DISPLAY',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DisplaySettings()),
                  );
                },
                goldColor: goldColor,
              ),
              
              const SizedBox(height: 16),
              
              // NOTIFICATIONS button
              _buildSettingsButton(
                icon: Icons.notifications_outlined,
                text: 'NOTIFICATIONS',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationSettings()),
                  );
                },
                goldColor: goldColor,
              ),
              
              const SizedBox(height: 16),
              
              // STORAGE button
              _buildSettingsButton(
                icon: Icons.sd_card_outlined,
                text: 'STORAGE',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StorageSettings()),
                  );
                },
                goldColor: goldColor,
              ),
              
              const SizedBox(height: 16),
              
              // CONTACT US button
              _buildSettingsButton(
                icon: Icons.phone_outlined,
                text: 'CONTACT US',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactUs()),
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
  
  // Helper method to create consistent settings buttons
  Widget _buildSettingsButton({
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}