import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/calc_entry.dart';
import '../../domain/usecases/evaluate_expression.dart';
import '../../../../services/voice/voice_input_service.dart';

class CalculatorState {
  final String currentExpression;
  final String result;
  final List<CalcEntry> history;
  final bool isScientificMode;
  final double memory;

  const CalculatorState({
    this.currentExpression = '',
    this.result = '0',
    this.history = const [],
    this.isScientificMode = false,
    this.memory = 0.0,
  });

  CalculatorState copyWith({
    String? currentExpression,
    String? result,
    List<CalcEntry>? history,
    bool? isScientificMode,
    double? memory,
  }) {
    return CalculatorState(
      currentExpression: currentExpression ?? this.currentExpression,
      result: result ?? this.result,
      history: history ?? this.history,
      isScientificMode: isScientificMode ?? this.isScientificMode,
      memory: memory ?? this.memory,
    );
  }
}

class CalculatorController extends StateNotifier<CalculatorState> {
  CalculatorController() : super(const CalculatorState());

  void appendToExpression(String value) {
    state = state.copyWith(currentExpression: state.currentExpression + value);
  }

  void setExpression(String value) {
    state = state.copyWith(currentExpression: value);
  }

  void clearExpression() {
    state = state.copyWith(currentExpression: '', result: '0');
  }

  void deleteLast() {
    if (state.currentExpression.isNotEmpty) {
      state = state.copyWith(
        currentExpression: state.currentExpression.substring(
          0,
          state.currentExpression.length - 1,
        ),
      );
    }
  }

  void calculate() {
    if (state.currentExpression.isEmpty) return;

    try {
      final result = ExpressionEvaluator.evaluate(state.currentExpression);

      final entry = CalcEntry(
        expression: state.currentExpression,
        result: result,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        result: result,
        history: [entry, ...state.history],
        currentExpression: result,
      );
    } catch (e) {
      state = state.copyWith(result: 'Error');
    }
  }

  void toggleScientificMode() {
    state = state.copyWith(isScientificMode: !state.isScientificMode);
  }

  void applyScientificFunction(String function) {
    final newExpression = ExpressionEvaluator.handleScientificFunction(
      state.currentExpression,
      function,
    );
    state = state.copyWith(currentExpression: newExpression);
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }

  void memoryAdd() {
    final currentValue = double.tryParse(state.result) ?? 0.0;
    state = state.copyWith(memory: state.memory + currentValue);
  }

  void memorySubtract() {
    final currentValue = double.tryParse(state.result) ?? 0.0;
    state = state.copyWith(memory: state.memory - currentValue);
  }

  void memoryRecall() {
    state = state.copyWith(
      currentExpression: state.memory.toString(),
      result: state.memory.toString(),
    );
  }

  void memoryClear() {
    state = state.copyWith(memory: 0.0);
  }

  void applyVoiceExpression(String voiceText) {
    final expression = VoiceInputService.parseToExpression(voiceText);
    if (expression.isEmpty) return;

    state = state.copyWith(currentExpression: expression);
    if (VoiceInputService.shouldAutoCalculate(voiceText)) {
      calculate();
    }
  }
}

final calculatorProvider =
    StateNotifierProvider<CalculatorController, CalculatorState>(
  (ref) => CalculatorController(),
);
