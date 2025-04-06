import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  bool isRecording = false;

  // This would need actual implementation with a voice recording package
  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
    // Here you would add actual recording functionality
    // using a package like flutter_sound or record
  }

  @override
  Widget build(BuildContext context) {
    // Define your gold color that matches the image
    final goldColor = const Color.fromARGB(255, 193, 154, 107);
    
    return BaseLayout(
      // ===========================appbar=======================
      appBarTitle: 'VOICE',
      
      // ================== Body ==================
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Microphone circle button
              GestureDetector(
                onTap: toggleRecording,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: goldColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Base microphone
                        Icon(
                          Icons.mic,
                          size: 70,
                          color: Colors.lightGreenAccent.shade100,
                        ),
                        // Green shadow/glow effect
                        Positioned(
                          bottom: 32,
                          child: Container(
                            width: 35,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Recording instructions text
              Text(
                isRecording ? 'Tap to stop recording' : 'Tap to start recording',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Upload voice note button
              TextButton.icon(
                onPressed: () {
                  // Implement file picking functionality
                  // You would need a package like file_picker
                },
                icon: const Icon(
                  Icons.upload,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text(
                  'upload a voice note',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}