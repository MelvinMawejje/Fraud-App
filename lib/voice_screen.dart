import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'Voice',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                // Add your onPressed logic here
              },
              icon: Icon(Icons.keyboard_voice,
                size: 100,
              ),),
            Text('Tap to start recording'),
            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  IconButton(
                onPressed: () {
                  // Add your onPressed logic here
                },
                icon: Icon(Icons.audio_file_sharp,
                  size: 40,
                ),),
                 Text('Upload voice audio'),
                ],
              ),
            )
          ],
        )
         
      ),
    );
  }
}