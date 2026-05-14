import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/calculator_controller.dart';
import '../widgets/calc_display.dart';
import '../widgets/calc_pad.dart';
import '../widgets/history_list.dart';
import '../../../../services/voice/voice_input_service.dart';

class CalculatorPage extends ConsumerStatefulWidget {
  const CalculatorPage({super.key});

  @override
  ConsumerState<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends ConsumerState<CalculatorPage> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none_rounded),
            onPressed: _isListening ? null : _startVoiceInput,
            tooltip: _isListening ? 'Listening...' : 'Voice input',
            style: IconButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(width: 8),
          if (state.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history_rounded),
              onPressed: () => _showHistoryDialog(context),
              tooltip: 'History',
              style: IconButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Display
              CalcDisplay(),
              SizedBox(height: 16),
              // Calculator Pad
              Expanded(child: CalcPad()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startVoiceInput() async {
    final controller = ref.read(calculatorProvider.notifier);

    setState(() {
      _isListening = true;
    });

    final voiceText = await VoiceInputService.recognizeSpeech();

    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }

    if (!mounted) return;

    if (voiceText == null || voiceText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No voice input detected. Try again.')),
      );
      return;
    }

    controller.applyVoiceExpression(voiceText);
    final parsed = VoiceInputService.parseToExpression(voiceText);
    if (parsed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not parse spoken expression.')),
      );
    }
  }

  void _showHistoryDialog(BuildContext context) {
    final controller = ref.read(calculatorProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calculation History'),
        content: SizedBox(
          width: double.maxFinite,
          child: HistoryList(
            onItemTap: (entry) {
              controller.appendToExpression(entry.result);
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.clearHistory(),
            child: const Text('Clear History'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
