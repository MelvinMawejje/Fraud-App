class PredictionRecord {
  final String text;
  final String result;
  final double probability;
  final DateTime timestamp;

  PredictionRecord({
    required this.text,
    required this.result,
    required this.probability,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'result': result,
      'probability': probability,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PredictionRecord.fromMap(Map<String, dynamic> map) {
    return PredictionRecord(
      text: map['text'],
      result: map['result'],
      probability: map['probability'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}