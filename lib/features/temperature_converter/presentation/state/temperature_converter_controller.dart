import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemperatureConverterState {
  final double inputValue;
  final String selectedUnit; // celsius, fahrenheit, kelvin
  final double celsiusValue;
  final double fahrenheitValue;
  final double kelvinValue;
  final String errorMessage;

  const TemperatureConverterState({
    this.inputValue = 0.0,
    this.selectedUnit = 'celsius',
    this.celsiusValue = 0.0,
    this.fahrenheitValue = 32.0,
    this.kelvinValue = 273.15,
    this.errorMessage = '',
  });

  TemperatureConverterState copyWith({
    double? inputValue,
    String? selectedUnit,
    double? celsiusValue,
    double? fahrenheitValue,
    double? kelvinValue,
    String? errorMessage,
  }) {
    return TemperatureConverterState(
      inputValue: inputValue ?? this.inputValue,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      celsiusValue: celsiusValue ?? this.celsiusValue,
      fahrenheitValue: fahrenheitValue ?? this.fahrenheitValue,
      kelvinValue: kelvinValue ?? this.kelvinValue,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TemperatureConverterController
    extends StateNotifier<TemperatureConverterState> {
  TemperatureConverterController() : super(const TemperatureConverterState());

  void setInputValue(String value) {
    final sanitized = value.replaceAll(',', '').trim();
    if (sanitized.isEmpty ||
        sanitized == '-' ||
        sanitized == '.' ||
        sanitized == '-.') {
      _convertTemperature(0, state.selectedUnit);
      return;
    }

    final input = double.tryParse(sanitized);
    if (input == null || input.isNaN || input.isInfinite) {
      state = state.copyWith(
        inputValue: 0,
        errorMessage: 'Invalid input',
        celsiusValue: 0,
        fahrenheitValue: 32,
        kelvinValue: 273.15,
      );
      return;
    }

    _convertTemperature(input, state.selectedUnit);
  }

  void setUnit(String unit) {
    state = state.copyWith(selectedUnit: unit);
    _convertTemperature(state.inputValue, unit);
  }

  void _convertTemperature(double value, String fromUnit) {
    try {
      double celsius = 0;

      // Convert input to Celsius first
      switch (fromUnit) {
        case 'celsius':
          celsius = value;
          break;
        case 'fahrenheit':
          celsius = (value - 32) * 5 / 9;
          break;
        case 'kelvin':
          celsius = value - 273.15;
          break;
      }

      // Convert from Celsius to all units
      final fahrenheit = (celsius * 9 / 5) + 32;
      final kelvin = celsius + 273.15;

      state = state.copyWith(
        inputValue: value,
        selectedUnit: fromUnit,
        celsiusValue: celsius,
        fahrenheitValue: fahrenheit,
        kelvinValue: kelvin,
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Conversion error');
    }
  }

  void clear() {
    state = const TemperatureConverterState();
  }
}

final temperatureConverterProvider = StateNotifierProvider<
    TemperatureConverterController, TemperatureConverterState>((ref) {
  return TemperatureConverterController();
});
