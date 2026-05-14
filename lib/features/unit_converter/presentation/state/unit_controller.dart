import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/unit_category.dart';
import '../../domain/usecases/convert_unit.dart';

class UnitConverterState {
  final UnitCategory selectedCategory;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double outputValue;

  const UnitConverterState({
    this.selectedCategory = UnitCategory.length,
    this.fromUnit = 'Meter',
    this.toUnit = 'Kilometer',
    this.inputValue = 1.0,
    this.outputValue = 0.001,
  });

  UnitConverterState copyWith({
    UnitCategory? selectedCategory,
    String? fromUnit,
    String? toUnit,
    double? inputValue,
    double? outputValue,
  }) {
    return UnitConverterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      inputValue: inputValue ?? this.inputValue,
      outputValue: outputValue ?? this.outputValue,
    );
  }
}

class UnitConverterController extends StateNotifier<UnitConverterState> {
  UnitConverterController() : super(const UnitConverterState());

  void selectCategory(UnitCategory category) {
    final units = category.units;
    state = state.copyWith(
      selectedCategory: category,
      fromUnit: units[0],
      toUnit: units.length > 1 ? units[1] : units[0],
    );
    _convert();
  }

  void setFromUnit(String unit) {
    state = state.copyWith(fromUnit: unit);
    _convert();
  }

  void setToUnit(String unit) {
    state = state.copyWith(toUnit: unit);
    _convert();
  }

  void setInputValue(String value) {
    final parsedValue = double.tryParse(value) ?? 0.0;
    state = state.copyWith(inputValue: parsedValue);
    _convert();
  }

  void swapUnits() {
    state = state.copyWith(
      fromUnit: state.toUnit,
      toUnit: state.fromUnit,
      inputValue: state.outputValue,
    );
    _convert();
  }

  void _convert() {
    final result = UnitConverter.convert(
      state.selectedCategory.name,
      state.fromUnit,
      state.toUnit,
      state.inputValue,
    );
    state = state.copyWith(outputValue: result);
  }
}

final unitConverterProvider =
    StateNotifierProvider<UnitConverterController, UnitConverterState>((ref) {
  return UnitConverterController();
});
