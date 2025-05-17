import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/voice_recording.dart';

class VoiceDataScreen extends StatefulWidget {
  const VoiceDataScreen({super.key});

  @override
  State<VoiceDataScreen> createState() => _VoiceDataScreenState();
}

class _VoiceDataScreenState extends State<VoiceDataScreen> {
  List<VoiceRecording> _recordings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/voice_recordings');
    
    if (!await recordingsDir.exists()) {
      setState(() => _isLoading = false);
      return;
    }

    final files = await recordingsDir.list().toList();
    
    // Skip if mounted check
    if (!mounted) return;

    setState(() {
      _recordings = files
          .where((file) => file is File && file.path.endsWith('.m4a'))
          .map((file) => VoiceRecording(
                filePath: file.path,
                fileName: file.path.split('/').last,
                createdDate: DateTime.now(), // Temporary placeholder
                duration: const Duration(seconds: 0),
              ))
          .toList();
      _isLoading = false;
    });
    
  } catch (e) {
    print('Error loading recordings: $e');
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
} // End of _loadRecordings method

  Future<Duration> _getAudioDuration(String path) async {
  try {
    final file = File(path);
    final metadata = await file.readAsBytes();
    // Simple fallback - returns 00:00 but prevents crashes
    return const Duration(seconds: 0);
    } catch (e) {
    return const Duration(seconds: 0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: ('Voice Recordings'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recordings.isEmpty
              ? const Center(child: Text('No recordings found'))
              : ListView.builder(
                  itemCount: _recordings.length,
                  itemBuilder: (context, index) {
                    final recording = _recordings[index];
                    return ListTile(
                      leading: const Icon(Icons.audio_file),
                      title: Text(recording.fileName),
                      subtitle: Text(
                        '${recording.createdDate.toString().substring(0, 16)}\n'
                        'Duration: ${recording.duration.toString().substring(0, 7)}'
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => _playRecording(recording.filePath),
                      ),
                    );
                  },
                ),
    );
  }

  void _playRecording(String path) {
    // Implement playback using audioplayers or just_audio
  }
} // End of _VoiceDataScreenState class