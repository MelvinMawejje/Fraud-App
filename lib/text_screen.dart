import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fraud_watch/Profile/models/prediction_record.dart';
import 'package:fraud_watch/Profile/services/prediction_storage.dart';
// Ensure flutter_dotenv is added to your pubspec.yaml and run 'flutter pub get'

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late TextEditingController textController;
  bool isLoading = false;
  String predictionResult = '';
  double fraudProbability = 0.0;

  final PredictionStorage _storage = PredictionStorage();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    loadEnv();
  }

  Future<void> loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

    Future<void> predictFraud(String text) async {
      setState(() {
        isLoading = true;
        predictionResult = '';
      });

      String truncateText(String text, {int maxTokens = 512}) {
        // Method 1: Character-based estimation (safer)
        final maxChars = maxTokens * 4; // 512 tokens ≈ 2048 characters
        return text.length > maxChars 
            ? text.substring(0, maxChars) 
            : text;

        // Method 2: Word-based estimation
        // final words = text.split(' ');
        // final maxWords = (maxTokens * 0.75).floor(); // 512 tokens ≈ 384 words
        // return words.take(maxWords).join(' ');
      }

        final truncatedText = truncateText(text, maxTokens: 500); // Leave room for special tokens

      try {
        final response = await http.post(
          Uri.parse('https://plk3hape62x22fmg.us-east-1.aws.endpoints.huggingface.cloud'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['HF_API_TOKEN']}',
            'Content-Type': 'application/json; charset=UTF-8', // Fix here
          },
          body: json.encode({
            "inputs": truncatedText,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final label = data[0]['label'] as String; // "SCAM" or "NOTSCAM"
          final score = data[0]['score'] as double;

         // Save the prediction record
        final record = PredictionRecord(
        text: truncatedText,
        result: label,
        probability: score,
        timestamp: DateTime.now(),
        );

        await _storage.savePrediction(record);

          setState(() {
            predictionResult = label == "SCAM" 
                ? 'SCAM (${(score * 100).toStringAsFixed(1)}%)'
                : 'NOT SCAM (${(score * 100).toStringAsFixed(1)}%)';
                fraudProbability = score;
          });
        } else {
          setState(() {
            predictionResult = 'API Error (${response.statusCode}): ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          predictionResult = 'Error: $e';
        });
      } finally {
        setState(() => isLoading = false);
      }
    }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle: 'Text',
     
      body: Center(
        child: Column(
        children: [
           
        
       Expanded(       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Upload text for fraud detection',
              style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: double.infinity),
              child: TextField(
                controller: textController,
                maxLines: null,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 5.0),
                  ),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (predictionResult.isNotEmpty)
              // Wrap the Padding with SingleChildScrollView to make the text scrollable
              // You might want to constrain the height of this area if the text can be very long
              Container(
              constraints: BoxConstraints(maxHeight: 200), // Example constraint: max height of 100 logical pixels
              child: SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  predictionResult,
                  style: TextStyle(
                  fontSize: 24,
                  color: fraudProbability > 0.7 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => textController.clear(),
                    child: Text('Clear',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 193, 154, 107),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (textController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter some text')));
                        return;
                      }
                      predictFraud(textController.text);
                    },
                    child: Text('Analyze Text',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 193, 154, 107),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(height: 50,),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 10),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reports');
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                   tooltip: 'View Reports',
                  child: Icon(Icons.assessment,
                       color:  Color.fromARGB(255, 193, 154, 107),
                       size: 50,
                  ),
                 
                ),
              ),
            )
          ],
        ),
        )
        ]
      )
      ),
    );
  }
}