import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/currency_converter/data/remote/currency_api_service.dart';
import '../features/currency_converter/domain/models/exchange_rate.dart';
import '../core/errors/failures.dart';
import '../features/currency_converter/presentation/state/currency_controller.dart';

class CurrencyRepository {
  final CurrencyApiService _apiService;

  CurrencyRepository(this._apiService);

  Future<ExchangeRate> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final rate = await _apiService.getExchangeRate(from, to);

      return ExchangeRate(
        baseCurrency: from,
        targetCurrency: to,
        rate: rate,
        amount: amount,
        convertedAmount: amount * rate,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw ConversionFailure('Currency conversion failed: $e');
    }
  }

  Future<Map<String, dynamic>> getLatestRates(String baseCurrency) async {
    try {
      return await _apiService.getLatestRates(baseCurrency);
    } catch (e) {
      throw NetworkFailure('Failed to fetch latest rates: $e');
    }
  }
}

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final apiService = ref.read(currencyApiServiceProvider);
  return CurrencyRepository(apiService);
});
