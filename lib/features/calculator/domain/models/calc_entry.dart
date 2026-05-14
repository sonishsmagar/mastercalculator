import 'package:equatable/equatable.dart';

class CalcEntry extends Equatable {
  final String expression;
  final String result;
  final DateTime timestamp;

  const CalcEntry({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  @override
  List<Object> get props => [expression, result, timestamp];
}
