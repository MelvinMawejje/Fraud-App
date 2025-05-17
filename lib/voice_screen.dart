import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:fraud_watch/services/fraud_detector.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  late final AudioRecorder _audioRecorder;
  bool _isRecording = false;
  String? _audioPath;
  Duration _recordDuration = Duration.zero;
  late Timer _timer;
  
  // Speech to text
  late stt.SpeechToText _speechToText;
  String _transcribedText = '';
  bool _isTranscribing = false;
  
  // Fraud detection
  late FraudDetector _fraudDetector;
  double? _fraudProbability;
  bool _isAnalyzing = false;
  final double _fraudThreshold = 0.7; // 70% threshold

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _speechToText = stt.SpeechToText();
    _fraudDetector = FraudDetector();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
  try {
    print('Starting model initialization...');
    
    // Show loading indicator
    setState(() {
      _isAnalyzing = true;
    });
    
    final success = await _fraudDetector.init();
    
    setState(() {
      _isAnalyzing = false;
    });
    
    if (!success) {
      print('Model initialization reported failure');
      _showError('Fraud detection model failed to load. Check console logs for details.');
    } else {
      print('Model initialization reported success');
    }
  } catch (e) {
    setState(() {
      _isAnalyzing = false;
    });
    print('Exception in _initializeModel: $e');
    _showError('Model error: ${e.toString()}');
  }
}

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _startRecording() async {
  if (await Permission.microphone.request().isGranted) {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') {
          _stopRecording(); // Auto stop and analyze
        }
      },
      onError: (error) {
        _showError('Speech error: ${error.errorMsg}');
      },
    );

    if (available) {
      setState(() {
        _isRecording = true;
        _recordDuration = Duration.zero;
        _transcribedText = '';
        _fraudProbability = null;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordDuration += const Duration(seconds: 1));
      });

      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
          });
        },
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
      );
    } else {
      _showError('Speech recognition not available');
    }
  } else {
    _showError('Microphone permission denied');
  }
}

Future<void> _stopRecording() async {
  try {
    await _speechToText.stop();
    _timer.cancel();
    setState(() => _isRecording = false);

    if (_transcribedText.isNotEmpty) {
      await _analyzeText(_transcribedText);
    } else {
      _showError('No speech detected');
    }
  } catch (e) {
    _showError('Stopping failed: ${e.toString()}');
  }
}


Future<void> _transcribeAudio() async {
  if (_audioPath == null) return;
  
  setState(() => _isTranscribing = true);
  
  try {
    // For emulator testing - hardcode some test cases
    final bool useTestData = true; // Set to false when testing with real audio
    
    if (useTestData) {
      // Simulate different cases for testing
      final testCases = [
        "Hello, this is a legitimate call about your appointment tomorrow.",
        "This is urgent! Your bank account has been compromised. I need your password immediately to secure your account.",
        "Hi, I'm calling from Microsoft. Your computer has a virus and I need remote access to fix it."
      ];
      
      // Choose a test case randomly or toggle between them
      final testText = testCases[1]; // Change index to test different cases
      
      setState(() {
        _transcribedText = testText;
        print("Using test transcription: $_transcribedText");
      });
    } else {
      // Actual speech recognition implementation
      bool available = await _speechToText.initialize();
      if (!available) throw Exception('Speech recognition unavailable');
      
      // This won't work with recorded audio, but keeping for reference
      await _speechToText.listen(
        onResult: (result) => setState(() => _transcribedText = result.recognizedWords),
      );
      
      await Future.delayed(const Duration(seconds: 2));
      await _speechToText.stop();
    }
  } catch (e) {
    print('Transcription error detail: ${e.toString()}');
    _showError('Transcription error: ${e.toString()}');
  } finally {
    setState(() => _isTranscribing = false);
  }
}

  Future<void> _analyzeText(String text) async {
    setState(() => _isAnalyzing = true);
    
    try {
      final probability = await _fraudDetector.predict(text);
      setState(() => _fraudProbability = probability);
      
      // Show final result
      _showResult(probability);
    } catch (e) {
      _showError('Analysis failed: ${e.toString()}');
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  void _showResult(double probability) {
    final isFraud = probability >= _fraudThreshold;
    final color = isFraud ? Colors.red : Colors.green;
    final icon = isFraud ? Icons.warning : Icons.check_circle;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              isFraud ? 'Fraud Detected!' : 'No Fraud Detected',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'Voice Fraud Detection',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Recording Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    IconButton(
                      iconSize: 80,
                      onPressed: _isRecording ? _stopRecording : _startRecording,
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: _isRecording ? Colors.red : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRecording 
                          ? 'Recording: ${_recordDuration.inMinutes.toString().padLeft(2, '0')}:${(_recordDuration.inSeconds % 60).toString().padLeft(2, '0')}'
                          : 'Tap to start recording',
                      style: TextStyle(
                        color: _isRecording ? Colors.red : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Results Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_isTranscribing || _isAnalyzing)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Processing...'),
                          ],
                        ),
                      ),

                    if (_transcribedText.isNotEmpty)
                      _buildResultCard(
                        title: 'Transcribed Text',
                        content: Text(_transcribedText),
                        icon: Icons.transcribe,
                      ),

                    if (_fraudProbability != null)
                      _buildResultCard(
                        title: 'Fraud Analysis',
                        content: _buildFraudResult(),
                        icon: _fraudProbability! >= _fraudThreshold 
                            ? Icons.warning 
                            : Icons.verified,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({required String title, required Widget content, required IconData icon}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildFraudResult() {
    final isFraud = _fraudProbability! >= _fraudThreshold;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isFraud ? Icons.warning : Icons.check_circle,
              color: isFraud ? Colors.red : Colors.green,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              isFraud ? 'SCAM' : 'NOTSCAM',
              style: TextStyle(
                color: isFraud ? Colors.red : Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: _fraudProbability,
          backgroundColor: Colors.grey[200],
          color: isFraud ? Colors.red : Colors.green,
          minHeight: 10,
        ),
        const SizedBox(height: 10),
        Text(
          'Probability: ${(_fraudProbability! * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        // Text(
        //   'Threshold: ${(_fraudThreshold * 100).toInt()}%',
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: Colors.grey,
        //   ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _timer.cancel();
    super.dispose();
  }
}