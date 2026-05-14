import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// OCR (Optical Character Recognition) Service
/// Provides utilities for scanning math expressions from images
/// Note: Production implementation requires integration with:
/// - google_ml_kit or firebase_ml_vision for text recognition
/// - Current version provides image capture interface for future enhancement
class OCRService {
  static final OCRService _instance = OCRService._internal();

  final ImagePicker _imagePicker = ImagePicker();

  OCRService._internal();

  factory OCRService() {
    return _instance;
  }

  /// Capture image from camera and extract text
  /// In production, integrate with Google ML Kit or Firebase Vision for real OCR
  Future<String?> captureFromCamera() async {
    try {
      debugPrint('[OCR] Starting camera capture');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        debugPrint('[OCR] Camera cancelled by user');
        return null;
      }

      debugPrint('[OCR] Image captured: ${image.path}');
      return await _recognizeText(image.path);
    } catch (e) {
      debugPrint('[OCR] Error capturing from camera: $e');
      rethrow;
    }
  }

  /// Pick image from gallery and extract text
  Future<String?> pickFromGallery() async {
    try {
      debugPrint('[OCR] Starting gallery picker');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        debugPrint('[OCR] Gallery cancelled by user');
        return null;
      }

      debugPrint('[OCR] Image selected: ${image.path}');
      return await _recognizeText(image.path);
    } catch (e) {
      debugPrint('[OCR] Error picking from gallery: $e');
      rethrow;
    }
  }

  /// Process image and extract text
  /// Production: Integrate with Google ML Kit or Firebase Vision for real OCR
  Future<String> _recognizeText(String imagePath) async {
    try {
      debugPrint('[OCR] Processing image: $imagePath');

      // Simulate OCR processing
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if file exists
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      // Integration steps for real OCR:
      // 1. Add google_mlkit_text_recognition or firebase_ml_vision package
      // 2. Initialize TextRecognizer: final recognizer = TextRecognizer(...)
      // 3. Create InputImage: final inputImage = InputImage.fromFilePath(imagePath)
      // 4. Process image: final recognizedText = await recognizer.processImage(inputImage)
      // 5. Extract text from recognizedText.blocks and lines
      // 6. Return cleaned text using cleanExpression()

      final fileName = file.path.split('/').last;
      return 'Image loaded: $fileName\n\nTo enable text recognition:\n1. Add text recognition package\n2. Initialize recognizer\n3. Process image\n4. Extract and clean text';
    } catch (e) {
      debugPrint('[OCR] Error processing image: $e');
      throw Exception('Failed to process image: $e');
    }
  }

  /// Clean extracted text to get valid math expression
  static String cleanExpression(String rawText) {
    // Remove extra spaces
    String cleaned = rawText.replaceAll(RegExp(r'\s+'), '');

    // Replace common OCR mistakes
    final replacements = {
      'l': '1', // lowercase L to 1
      'O': '0', // uppercase O to 0
      'S': '5', // uppercase S to 5
      'I': '1', // uppercase I to 1
      '|': '1', // pipe to 1
      'x': '*', // x to multiplication
    };

    replacements.forEach((key, value) {
      cleaned = cleaned.replaceAll(key, value);
    });

    // Keep only valid mathematical characters
    cleaned = cleaned.replaceAll(RegExp(r'[^0-9+\-*/.(),π^√e]'), '');

    return cleaned;
  }

  /// Validate if extracted expression is a valid math expression
  static bool isValidExpression(String expression) {
    // Basic validation
    if (expression.isEmpty) return false;

    // Check for balanced parentheses
    int parenCount = 0;
    for (final char in expression.split('')) {
      if (char == '(') parenCount++;
      if (char == ')') parenCount--;
      if (parenCount < 0) return false;
    }
    if (parenCount != 0) return false;

    // Check that it doesn't start or end with operator
    final operators = ['+', '-', '*', '/', '(', ')'];
    if (operators.contains(expression[0])) return false;
    if (operators.contains(expression[expression.length - 1])) return false;

    return true;
  }

  /// Dispose resources
  void dispose() {
    try {
      debugPrint('[OCR] Resources disposed');
    } catch (e) {
      debugPrint('[OCR] Error disposing resources: $e');
    }
  }
}
