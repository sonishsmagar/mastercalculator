// test/unit/calculator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:master_calculator/features/calculator/domain/usecases/evaluate_expression.dart';

void main() {
  test('Basic addition calculation', () {
    expect(ExpressionEvaluator.evaluate('2+2'), '4');
  });

  test('Complex expression with parentheses', () {
    expect(ExpressionEvaluator.evaluate('(2+3)*4'), '20');
  });
}
