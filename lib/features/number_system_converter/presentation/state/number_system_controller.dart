import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberSystemState {
  final String decimalInput;
  final String binaryOutput;
  final String octalOutput;
  final String hexadecimalOutput;
  final String selectedInputBase; // decimal, binary, octal, hexadecimal
  final String errorMessage;

  const NumberSystemState({
    this.decimalInput = '0',
    this.binaryOutput = '0',
    this.octalOutput = '0',
    this.hexadecimalOutput = '0',
    this.selectedInputBase = 'decimal',
    this.errorMessage = '',
  });

  NumberSystemState copyWith({
    String? decimalInput,
    String? binaryOutput,
    String? octalOutput,
    String? hexadecimalOutput,
    String? selectedInputBase,
    String? errorMessage,
  }) {
    return NumberSystemState(
      decimalInput: decimalInput ?? this.decimalInput,
      binaryOutput: binaryOutput ?? this.binaryOutput,
      octalOutput: octalOutput ?? this.octalOutput,
      hexadecimalOutput: hexadecimalOutput ?? this.hexadecimalOutput,
      selectedInputBase: selectedInputBase ?? this.selectedInputBase,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class NumberSystemController extends StateNotifier<NumberSystemState> {
  NumberSystemController() : super(const NumberSystemState());

  void setInputBase(String base) {
    if (base == state.selectedInputBase) return;
    final currentInput = state.decimalInput;
    final decimalValue =
        _parseInputToDecimal(currentInput, state.selectedInputBase);

    if (decimalValue == null) {
      state = state.copyWith(
        selectedInputBase: base,
        decimalInput: '0',
        binaryOutput: '0',
        octalOutput: '0',
        hexadecimalOutput: '0',
        errorMessage: '',
      );
      return;
    }

    final newInput = _formatDecimalForBase(decimalValue, base);
    state = state.copyWith(selectedInputBase: base);
    _convertFromBase(newInput, base);
  }

  void appendInput(String value) {
    final newInput =
        (state.decimalInput == '0') ? value : state.decimalInput + value;
    _convertFromBase(newInput, state.selectedInputBase);
  }

  void backspace() {
    if (state.decimalInput.isEmpty || state.decimalInput.length == 1) {
      state = state.copyWith(decimalInput: '0', errorMessage: '');
      _convertFromBase('0', state.selectedInputBase);
    } else {
      final newInput =
          state.decimalInput.substring(0, state.decimalInput.length - 1);
      _convertFromBase(newInput, state.selectedInputBase);
    }
  }

  void clear() {
    state = const NumberSystemState();
  }

  void _convertFromBase(String input, String fromBase) {
    try {
      final decimalValue = _parseInputToDecimal(input, fromBase);
      if (decimalValue == null) {
        state = state.copyWith(
          decimalInput: input,
          errorMessage: 'Invalid input',
        );
        return;
      }

      state = state.copyWith(
        decimalInput: input,
        binaryOutput: decimalValue.toRadixString(2),
        octalOutput: decimalValue.toRadixString(8),
        hexadecimalOutput: decimalValue.toRadixString(16).toUpperCase(),
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        decimalInput: input,
        errorMessage: 'Invalid input',
      );
    }
  }

  int? _parseInputToDecimal(String input, String fromBase) {
    switch (fromBase) {
      case 'decimal':
        return int.tryParse(input);
      case 'binary':
        if (!RegExp(r'^[01]*$').hasMatch(input)) return null;
        return int.tryParse(input, radix: 2);
      case 'octal':
        if (!RegExp(r'^[0-7]*$').hasMatch(input)) return null;
        return int.tryParse(input, radix: 8);
      case 'hexadecimal':
        if (!RegExp(r'^[0-9A-Fa-f]*$').hasMatch(input)) return null;
        return int.tryParse(input, radix: 16);
      default:
        return null;
    }
  }

  String _formatDecimalForBase(int value, String base) {
    switch (base) {
      case 'decimal':
        return value.toString();
      case 'binary':
        return value.toRadixString(2);
      case 'octal':
        return value.toRadixString(8);
      case 'hexadecimal':
        return value.toRadixString(16).toUpperCase();
      default:
        return value.toString();
    }
  }
}

final numberSystemProvider =
    StateNotifierProvider<NumberSystemController, NumberSystemState>((ref) {
  return NumberSystemController();
});
