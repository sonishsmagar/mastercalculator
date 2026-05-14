import 'package:equatable/equatable.dart';

class ScientificCalculation extends Equatable {
  final String input;
  final String result;
  final String lastFunction;
  final String angleMode;

  const ScientificCalculation({
    this.input = '',
    this.result = '0',
    this.lastFunction = '',
    this.angleMode = AngleMode.degrees,
  });

  ScientificCalculation copyWith({
    String? input,
    String? result,
    String? lastFunction,
    String? angleMode,
  }) {
    return ScientificCalculation(
      input: input ?? this.input,
      result: result ?? this.result,
      lastFunction: lastFunction ?? this.lastFunction,
      angleMode: angleMode ?? this.angleMode,
    );
  }

  @override
  List<Object?> get props => [input, result, lastFunction, angleMode];
}

class ScientificConstants {
  static const double pi = 3.141592653589793;
  static const double e = 2.718281828459045;
  static const double phi = 1.618033988749895; // Golden ratio
  
  static const Map<String, double> constants = {
    'π': pi,
    'e': e,
    'φ': phi,
  };
}

class AngleMode {
  static const String degrees = 'DEG';
  static const String radians = 'RAD';
}
