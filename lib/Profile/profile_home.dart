import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      appBarTitle: 'Profile',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to your profile',
              style: TextStyle(
                fontSize: 20,
              ),),
            SizedBox(height: 20),
            Text('You can view your profile here',
              style: TextStyle(
                fontSize: 20,
              ),),
          ],
        ),
      ),
    );
  }
}