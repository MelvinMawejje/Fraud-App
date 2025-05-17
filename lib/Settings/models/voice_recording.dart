class VoiceRecording {
  final String filePath;
  final String fileName;
  final DateTime createdDate;
  final Duration duration;

  VoiceRecording({
    required this.filePath,
    required this.fileName,
    required this.createdDate,
    required this.duration,
  });
}