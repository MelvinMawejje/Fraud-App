import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(appBarTitle: 'settings',
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text('Welcome to your settings',
             style: TextStyle(
               fontSize: 20,
             ),),
           SizedBox(height: 20),
           Text('You can view your settings here',
             style: TextStyle(
               fontSize: 20,
             ),),
         ],
       ),
     ),);
  }
}