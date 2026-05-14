import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/calculator/domain/models/calc_entry.dart';
import '../features/calculator/domain/usecases/evaluate_expression.dart';
import '../core/errors/failures.dart';

class CalculatorRepository {
  Future<String> evaluateExpression(String expression) async {
    try {
      return ExpressionEvaluator.evaluate(expression);
    } catch (e) {
      throw CalculationFailure('Calculation failed: $e');
    }
  }

  List<CalcEntry> filterHistory(List<CalcEntry> history, String query) {
    return history
        .where((entry) =>
            entry.expression.toLowerCase().contains(query.toLowerCase()) ||
            entry.result.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<CalcEntry> sortHistoryByDate(List<CalcEntry> history,
      {bool ascending = false}) {
    history.sort((a, b) => ascending
        ? a.timestamp.compareTo(b.timestamp)
        : b.timestamp.compareTo(a.timestamp));
    return history;
  }
}

final calculatorRepositoryProvider = Provider<CalculatorRepository>((ref) {
  return CalculatorRepository();
});
