import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputService {
  static final SpeechToText _speech = SpeechToText();
  static bool _initialized = false;

  static Future<bool> _ensureInitialized() async {
    if (_initialized) return true;
    _initialized = await _speech.initialize();
    return _initialized;
  }

  static Future<String?> recognizeSpeech({
    Duration listenFor = const Duration(seconds: 7),
  }) async {
    try {
      if (!await _ensureInitialized()) return null;

      if (_speech.isListening) {
        await _speech.stop();
      }

      final completer = Completer<String?>();
      String recognized = '';

      final timeout = Timer(listenFor + const Duration(seconds: 2), () async {
        if (_speech.isListening) {
          await _speech.stop();
        }
        if (!completer.isCompleted) {
          final text = recognized.trim();
          completer.complete(text.isEmpty ? null : text);
        }
      });

      await _speech.listen(
        listenFor: listenFor,
        pauseFor: const Duration(seconds: 2),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
        ),
        onResult: (result) {
          recognized = result.recognizedWords;
          if (result.finalResult && !completer.isCompleted) {
            final text = recognized.trim();
            completer.complete(text.isEmpty ? null : text);
          }
        },
      );

      final result = await completer.future;
      timeout.cancel();
      if (_speech.isListening) {
        await _speech.stop();
      }
      return result;
    } catch (_) {
      return null;
    }
  }

  static String parseToExpression(String voiceText) {
    String text = voiceText.toLowerCase().trim();

    final replacements = <MapEntry<String, String>>[
      const MapEntry('multiplied by', '×'),
      const MapEntry('divided by', '÷'),
      const MapEntry('open bracket', '('),
      const MapEntry('close bracket', ')'),
      const MapEntry('open parenthesis', '('),
      const MapEntry('close parenthesis', ')'),
      const MapEntry('to the power of', '^'),
      const MapEntry('point', '.'),
      const MapEntry('times', '×'),
      const MapEntry('multiply', '×'),
      const MapEntry('x', '×'),
      const MapEntry('plus', '+'),
      const MapEntry('add', '+'),
      const MapEntry('minus', '-'),
      const MapEntry('subtract', '-'),
      const MapEntry('divide', '÷'),
      const MapEntry('by', ''),
      const MapEntry('equals', ''),
      const MapEntry('equal', ''),
      const MapEntry('calculate', ''),
      const MapEntry('what is', ''),
      const MapEntry('percent', '%'),
      const MapEntry('percentage', '%'),
      const MapEntry('pi', 'π'),
      const MapEntry('left bracket', '('),
      const MapEntry('right bracket', ')'),
    ];

    final digitWords = <String, String>{
      'zero': '0',
      'one': '1',
      'two': '2',
      'three': '3',
      'four': '4',
      'five': '5',
      'six': '6',
      'seven': '7',
      'eight': '8',
      'nine': '9',
      'ten': '10',
    };

    for (final replacement in replacements) {
      text = text.replaceAll(replacement.key, replacement.value);
    }
    digitWords.forEach((word, digit) {
      text = text.replaceAll(word, digit);
    });

    text = text.replaceAll(RegExp(r'\s+'), '');
    text = text.replaceAll(RegExp(r'[^0-9+\-×÷().^%πe.]'), '');
    return text;
  }

  static List<String> parseVoiceInput(String voiceText) {
    final expression = parseToExpression(voiceText);
    return expression.isEmpty ? const [] : [expression];
  }

  static bool shouldAutoCalculate(String voiceText) {
    final text = voiceText.toLowerCase();
    return text.contains('equal') ||
        text.contains('equals') ||
        text.contains('calculate') ||
        text.contains('result');
  }

  static Future<bool> hasMicrophoneAccess() async {
    try {
      return _ensureInitialized();
    } catch (_) {
      return false;
    }
  }
}
