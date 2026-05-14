import '../models/exchange_rate.dart';

class ConvertCurrency {
  static ExchangeRate convert({
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    required double amount,
  }) {
    final convertedAmount = amount * rate;

    return ExchangeRate(
      baseCurrency: baseCurrency,
      targetCurrency: targetCurrency,
      rate: rate,
      amount: amount,
      convertedAmount: convertedAmount,
      lastUpdated: DateTime.now(),
    );
  }
}
