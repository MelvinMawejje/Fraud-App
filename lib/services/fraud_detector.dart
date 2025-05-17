import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FraudDetector {
  Interpreter? _interpreter;
  List<String>? _vocab;
  int _seqLength = 0; // Default value
  
  Future<bool> init() async {
    try { 
      // Debug: Check if assets exist
      print('Debugging asset paths...');
      try {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        print('Asset manifest loaded successfully');
        print('Model in manifest: ${manifestContent.contains('assets/models/model_francis.tflite')}');
        print('Vocab in manifest: ${manifestContent.contains('assets/models/vocab.txt')}');
      } catch (e) {
        print('Failed to load asset manifest: $e');
      }
      
      // First, try to load the vocabulary file as a test
      try {
        print('Attempting to load vocabulary file...');
        final vocabString = await rootBundle.loadString('assets/models/vocab.txt');
        _vocab = vocabString.trim().split('\n');
        print('Vocabulary loaded with ${_vocab!.length} entries');
      } catch (e) {
        print('Vocabulary loading failed: $e');
        return false; // Exit early if vocab fails
      }
      
      // Try multiple methods to load the model
      print('Attempting to load TFLite model...');
      
      // Method 1: Direct asset loading
      try {
        print('Method 1: Loading from asset path');
        _interpreter = await Interpreter.fromAsset('assets/models/model_francis.tflite');
        print('Method 1 succeeded!');
      } catch (e) {
        print('Method 1 failed: $e');
        
        // Method 2: Copy to temp file and load
        try {
          print('Method 2: Loading via temporary file');
          final modelData = await rootBundle.load('assets/models/model_francis.tflite');
          print('Asset loaded, size: ${modelData.lengthInBytes} bytes');
          
          final appDir = await getApplicationDocumentsDirectory();
          final modelFile = File('${appDir.path}/model_francis.tflite');
          await modelFile.writeAsBytes(modelData.buffer.asUint8List());
          print('File written to: ${modelFile.path}');
          
          _interpreter = await Interpreter.fromFile(modelFile);
          print('Method 2 succeeded!');
        } catch (e) {
          print('Method 2 failed: $e');
          
          // Method 3: Try with buffer
          try {
            print('Method 3: Loading from buffer');
            final modelData = await rootBundle.load('assets/models/model_francis.tflite');
            final buffer = modelData.buffer;
            final list = buffer.asUint8List();
            _interpreter = await Interpreter.fromBuffer(list);
            print('Method 3 succeeded!');
          } catch (e) {
            print('Method 3 failed: $e');
            print('All loading methods failed');
            return false;
          }
        }
      }
      
      // Get model details
      try {
        print('Getting model input/output details');
        final inputTensor = _interpreter!.getInputTensors().first;
        _seqLength = inputTensor.shape[1];
        print('Model parameters: sequence length = $_seqLength');
        print('Input shape: ${inputTensor.shape}');
        print('Output shape: ${_interpreter!.getOutputTensors().first.shape}');
      } catch (e) {
        print('Failed to get model details: $e');
        return false;
      }
      
      print('Model initialization successful!');
      return true;
    } catch (e) {
      print('Unexpected error in init(): $e');
      return false;
    }
  }
  
  Future<double> predict(String text) async {
  try {
    if (_interpreter == null || _vocab == null) {
      print('Warning: predict() called before successful initialization');
      return 0.5; // Default value
    }
    
    // 1. Tokenize and preprocess text
    print('Tokenizing text: "${text.substring(0, min(20, text.length))}..."');
    final inputIds = _tokenizeText(text);
    print('Tokenized to ${inputIds.length} tokens');
    
    // 2. Create input tensor - need to match shape [1, sequence_length]
    var inputData = [List<int>.filled(_seqLength, 0)]; // Note the nesting to create 2D array
    for (int i = 0; i < min(inputIds.length, _seqLength); i++) {
      inputData[0][i] = inputIds[i];
    }
    
    // 3. Create output container with proper shape [1, 2]
    var outputShape = _interpreter!.getOutputTensor(0).shape;
    print('Creating output buffer with shape: $outputShape');
    var outputData = List.generate(
      outputShape[0], 
      (_) => List<double>.filled(outputShape[1], 0.0)
    );
    
    // 4. Run inference
    print('Running inference...');
    _interpreter!.run(inputData, outputData);
    
    // 5. Get prediction (assuming first value is fraud probability)
    final result = outputData[0][0]; // Get first value from [1,2] output
    print('Prediction result: $result');
    return result;
  } catch (e) {
    print('Prediction error: $e');
    throw Exception('Prediction failed: $e');
  }
}
  
  List<int> _tokenizeText(String text) {
    if (_vocab == null) {
      print('Error: Vocabulary not loaded');
      return List.filled(_seqLength, 0);
    }
    
    // Basic tokenization - adjust based on your tokenizer_config.json
    final words = text.toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'));
    
    print('Text split into ${words.length} words');
    
    // Convert words to token IDs with padding/truncation
    return List<int>.generate(_seqLength, (i) {
      if (i < words.length) {
        final index = _vocab!.indexOf(words[i]);
        if (index != -1) {
          return index;
        }
        // Unknown token
        final unkIndex = _vocab!.indexOf('[UNK]');
        return unkIndex != -1 ? unkIndex : 0;
      }
      return 0; // Padding with 0
    });
  }
}

// Helper function for min
int min(int a, int b) {
  return a < b ? a : b;
}