import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final double amount;
  final double convertedAmount;
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.amount,
    required this.convertedAmount,
    required this.lastUpdated,
  });

  ExchangeRate copyWith({
    String? baseCurrency,
    String? targetCurrency,
    double? rate,
    double? amount,
    double? convertedAmount,
    DateTime? lastUpdated,
  }) {
    return ExchangeRate(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object> get props => [
        baseCurrency,
        targetCurrency,
        rate,
        amount,
        convertedAmount,
        lastUpdated
      ];
}
