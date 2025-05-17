import 'package:fraud_watch/Profile/models/prediction_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PredictionStorage {
  static const _key = 'predictionRecords';

  Future<void> initialize() async {
    await _migrateOldData();
  }

  Future<void> _migrateOldData() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(_key) ?? [];
    
    final validEntries = stringList.where((entry) {
      try {
        json.decode(entry);
        return true;
      } catch (_) {
        return false;
      }
    }).toList();

    if (validEntries.length != stringList.length) {
      await prefs.setStringList(_key, validEntries);
    }
  }

  Future<void> savePrediction(PredictionRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getPredictions();
    records.add(record);
    
    final jsonList = records.map((r) => json.encode(r.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<List<PredictionRecord>> getPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(_key) ?? [];
    
    return stringList.map((jsonStr) {
      try {
        final map = json.decode(jsonStr) as Map<String, dynamic>;
        return PredictionRecord.fromMap(map);
      } catch (e) {
        print('Error parsing record: $e');
        return PredictionRecord(
          text: 'Corrupted Entry',
          result: 'ERROR',
          probability: 0.0,
          timestamp: DateTime.now(),
        );
      }
    }).toList();
  }

  Future<void> deletePrediction(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getPredictions();
    records.removeAt(index);
    
    final jsonList = records.map((r) => json.encode(r.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }
}