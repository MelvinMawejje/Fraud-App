import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class Homeextends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your gold color that matches the image
    final goldColor = const Color.fromARGB(255, 193, 154, 107);
    
    return BaseLayout(
      // ===========================appbar=======================
      appBarTitle: 'Fraud Watch',
      
      // ================== Body ==================
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How do you want to check for fraud?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: goldColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Voice option (microphone)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/voice_screen');
                },
                child: Container(
                  width: 120,
                  height: 120,
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
                          size: 60,
                          color: Colors.lightGreenAccent.shade100,
                        ),
                        // Green shadow/glow effect
                        Positioned(
                          bottom: 28,
                          child: Container(
                            width: 30,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Text option (document)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/text_screen');
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: goldColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'TXT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
}