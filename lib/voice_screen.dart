import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final Record _audioRecorder = Record(); // Ensure the `record` package is properly imported
  bool _isRecording = false;
  String? _audioPath;
  Duration _recordDuration = Duration.zero;
  
  // Add timer for recording duration
  late Timer _timer;

  @override
  void dispose() {
    _audioRecorder.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // Request microphone permission
      if (await Permission.microphone.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording.m4a';
        
        await _audioRecorder.start(
          path: path,
          encoder: AudioEncoder.aacLc, // Specify the encoder
          bitRate: 128000, // Optional: Set the bit rate
          samplingRate: 44100, // Optional: Set the sampling rate
        );
        
        setState(() {
          _isRecording = true;
          _audioPath = path;
          _recordDuration = Duration.zero;
        });
        
        // Start timer
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration += const Duration(seconds: 1);
          });
        });
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _timer.cancel();
      setState(() {
        _isRecording = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording saved to $_audioPath')),
      );
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'Voice',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recording Indicator
            if (_isRecording)
              Column(
                children: [
                  const Icon(Icons.radio_button_checked, color: Colors.red, size: 30),
                  Text(
                    'Recording: ${_recordDuration.inMinutes.toString().padLeft(2, '0')}:'
                    '${(_recordDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Main Record Button
            IconButton(
              onPressed: () async {
                if (_isRecording) {
                  await _stopRecording();
                } else {
                  await _startRecording();
                }
              },
              icon: Icon(
                _isRecording ? Icons.stop : Icons.keyboard_voice,
                size: 100,
                color: _isRecording ? Colors.red : Colors.black,
              ),
            ),
            Text(_isRecording ? 'Recording...' : 'Tap to start recording'),

            const SizedBox(height: 40),

            // Audio File Display
            if (_audioPath != null && !_isRecording)
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.audio_file_sharp, size: 40),
                    const SizedBox(width: 10),
                    Text('Recording saved: ${_audioPath!.split('/').last}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}