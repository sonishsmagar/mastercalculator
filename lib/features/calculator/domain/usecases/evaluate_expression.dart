import 'package:math_expressions/math_expressions.dart';

class ExpressionEvaluator {
  static String evaluate(String expression) {
    try {
      // Clean the expression
      String cleanExpression = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', 'pi')
          .replaceAll('e', 'e');

      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(cleanExpression);
      ContextModel context = ContextModel();

      double evalResult = exp.evaluate(EvaluationType.REAL, context);

      // Format the result
      if (evalResult % 1 == 0) {
        return evalResult.toInt().toString();
      } else {
        return evalResult
            .toStringAsFixed(6)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      throw const FormatException('Invalid expression');
    }
  }

  static String handleScientificFunction(
    String currentExpression,
    String function,
  ) {
    switch (function) {
      case 'sin':
      case 'cos':
      case 'tan':
      case 'log':
      case 'ln':
        return '$function($currentExpression)';
      case 'sqrt':
        return 'sqrt($currentExpression)';
      case '^':
        return '$currentExpression^';
      case 'π':
        return '$currentExpressionπ';
      case 'e':
        return '${currentExpression}e';
      default:
        return currentExpression;
    }
  }
}
