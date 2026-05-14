class NumberUtils {
  static String formatDouble(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      // Remove trailing zeros
      return value.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
    }
  }

  static double? tryParse(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  static String formatCurrency(double amount, {int decimalDigits = 2}) {
    return amount.toStringAsFixed(decimalDigits);
  }
}
