import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/ocr/ocr_service.dart';

class OCRCalculatorPage extends ConsumerStatefulWidget {
  const OCRCalculatorPage({super.key});

  @override
  ConsumerState<OCRCalculatorPage> createState() => _OCRCalculatorPageState();
}

class _OCRCalculatorPageState extends ConsumerState<OCRCalculatorPage> {
  final OCRService _ocrService = OCRService();
  String? _capturedText;
  String? _cleanedExpression;
  bool _isProcessing = false;
  String? _error;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _scanWithCamera() async {
    await _processImage(_ocrService.captureFromCamera());
  }

  Future<void> _uploadImage() async {
    await _processImage(_ocrService.pickFromGallery());
  }

  Future<void> _processImage(Future<String?> imageOperation) async {
    if (mounted) {
      setState(() {
        _isProcessing = true;
        _error = null;
      });
    }

    try {
      final extractedText = await imageOperation;

      if (!mounted) return;

      if (extractedText == null) {
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      setState(() {
        _capturedText = extractedText;
        _cleanedExpression = OCRService.cleanExpression(extractedText);
        _isProcessing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_error ?? 'Unknown error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: 0.3,
                      ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan Math Expressions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use your camera or upload an image to extract mathematical expressions with AI-powered OCR.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Camera Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan with Camera'),
                onPressed: _isProcessing ? null : _scanWithCamera,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Upload Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Upload Image'),
                onPressed: _isProcessing ? null : _uploadImage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Processing State
            if (_isProcessing) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Extracting text from image...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error ?? '',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else if (_capturedText != null) ...[
              // Raw Extracted Text
              Text(
                'Extracted Text',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Text(
                  _capturedText!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),

              // Cleaned Math Expression
              Text(
                'Math Expression',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cleanedExpression ?? '(No expression found)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (_cleanedExpression != null &&
                        _cleanedExpression!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Ready to calculate',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                  ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate'),
                  onPressed: _cleanedExpression != null &&
                          _cleanedExpression!.isNotEmpty
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Copy the expression to calculator to evaluate',
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  onPressed: () {
                    setState(() {
                      _capturedText = null;
                      _cleanedExpression = null;
                      _error = null;
                    });
                  },
                ),
              ),
            ] else ...[
              // Placeholder
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_search,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No image selected',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take a photo or upload an image to scan',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Features
            if (_capturedText == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(context, '📸', 'Camera Capture',
                      'Take a photo of a math expression'),
                  const SizedBox(height: 8),
                  _buildFeatureItem(context, '📁', 'Image Upload',
                      'Select an image from your gallery'),
                  const SizedBox(height: 8),
                  _buildFeatureItem(context, '🤖', 'AI Text Recognition',
                      'Extract text using Google ML Kit'),
                  const SizedBox(height: 8),
                  _buildFeatureItem(context, '✨', 'Auto Cleanup',
                      'Automatically clean recognized text'),
                ],
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, String icon, String title, String description) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
