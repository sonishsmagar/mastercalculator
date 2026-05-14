import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/scientific_calculation.dart';
import '../../../calculator/domain/usecases/evaluate_expression.dart';

class ScientificCalculatorController
    extends StateNotifier<ScientificCalculation> {
  ScientificCalculatorController() : super(const ScientificCalculation());

  String get angleMode => state.angleMode;

  void toggleAngleMode() {
    final newMode = state.angleMode == AngleMode.degrees
        ? AngleMode.radians
        : AngleMode.degrees;
    state = state.copyWith(angleMode: newMode);
  }

  void appendInput(String value) {
    final newInput = state.input + value;
    state = state.copyWith(input: newInput);
  }

  void clear() {
    state = const ScientificCalculation();
  }

  void backspace() {
    if (state.input.isEmpty) return;
    final newInput = state.input.substring(0, state.input.length - 1);
    state = state.copyWith(input: newInput);
  }

  void applySin() {
    _applyTrigonometric('sin');
  }

  void applyCos() {
    _applyTrigonometric('cos');
  }

  void applyTan() {
    _applyTrigonometric('tan');
  }

  void _applyTrigonometric(String func) {
    try {
      final value = double.parse(state.input);
      final radians =
          state.angleMode == AngleMode.degrees ? value * pi / 180 : value;

      double result;
      switch (func) {
        case 'sin':
          result = sin(radians);
          break;
        case 'cos':
          result = cos(radians);
          break;
        case 'tan':
          result = tan(radians);
          break;
        default:
          result = 0;
      }

      state = state.copyWith(
        result: result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), ''),
        lastFunction: func.toUpperCase(),
      );
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }

  void applyLog() {
    try {
      final value = double.parse(state.input);
      if (value <= 0) {
        state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
        return;
      }
      final result = log(value) / ln10;
      state = state.copyWith(
        result: result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), ''),
        lastFunction: 'LOG',
      );
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }

  void applyLn() {
    try {
      final value = double.parse(state.input);
      if (value <= 0) {
        state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
        return;
      }
      final result = log(value);
      state = state.copyWith(
        result: result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), ''),
        lastFunction: 'LN',
      );
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }

  void applySqrt() {
    try {
      final value = double.parse(state.input);
      if (value < 0) {
        state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
        return;
      }
      final result = sqrt(value);
      state = state.copyWith(
        result: result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), ''),
        lastFunction: '√',
      );
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }

  void applyPower(int exponent) {
    try {
      final value = double.parse(state.input);
      final result = pow(value, exponent).toDouble();
      state = state.copyWith(
        result: result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), ''),
        lastFunction: 'POW($exponent)',
      );
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }

  void applyFactorial() {
    try {
      final value = int.parse(state.input);
      if (value < 0) {
        state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
        return;
      }
      if (value > 20) {
        state = state.copyWith(
          result: 'Too large',
          lastFunction: 'ERROR',
        );
        return;
      }

      int result = 1;
      for (int i = 2; i <= value; i++) {
        result *= i;
      }

      state = state.copyWith(
        result: result.toString(),
        lastFunction: 'FACTORIAL',
      );
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }

  void addConstant(String constant) {
    final value = ScientificConstants.constants[constant];
    if (value != null) {
      final newInput = state.input + value.toString();
      state = state.copyWith(input: newInput);
    }
  }

  void calculate() {
    if (state.input.isEmpty) return;
    try {
      final result = ExpressionEvaluator.evaluate(state.input);
      state = state.copyWith(result: result, lastFunction: 'RESULT');
    } catch (e) {
      state = state.copyWith(result: 'Error', lastFunction: 'ERROR');
    }
  }
}

final scientificCalculatorProvider = StateNotifierProvider<
    ScientificCalculatorController, ScientificCalculation>(
  (ref) => ScientificCalculatorController(),
);

const ln10 = 2.302585092994046;
