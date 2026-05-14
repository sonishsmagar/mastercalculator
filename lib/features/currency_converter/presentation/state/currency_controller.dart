import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/currency_api_service.dart';
import '../../domain/models/exchange_rate.dart';
import '../../domain/usecases/convert_currency.dart';

class CurrencyConverterState {
  final String baseCurrency;
  final String targetCurrency;
  final double amount;
  final ExchangeRate? exchangeRate;
  final bool isLoading;
  final String errorMessage;
  final Map<String, String> availableCurrencies;
  final List<Map<String, dynamic>> historicalRates;
  final bool isLoadingHistory;
  final Map<String, double> multiCurrencyComparison; // NEW - for multi-currency view
  final bool showComparison; // NEW - toggle between single and multi-currency

  const CurrencyConverterState({
    this.baseCurrency = 'USD',
    this.targetCurrency = 'EUR',
    this.amount = 1.0,
    this.exchangeRate,
    this.isLoading = false,
    this.errorMessage = '',
    this.availableCurrencies = const {
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'NPR': 'Nepalese Rupee',
      'INR': 'Indian Rupee',
      'CAD': 'Canadian Dollar',
      'AUD': 'Australian Dollar',
      'CHF': 'Swiss Franc',
      'CNY': 'Chinese Yuan',
      'KRW': 'South Korean Won',
      'MXN': 'Mexican Peso',
      'BRL': 'Brazilian Real',
      'ZAR': 'South African Rand',
      'SGD': 'Singapore Dollar',
      'HKD': 'Hong Kong Dollar',
      'NZD': 'New Zealand Dollar',
      'SEK': 'Swedish Krona',
      'NOK': 'Norwegian Krone',
      'DKK': 'Danish Krone',
      'PLN': 'Polish Zloty',
      'THB': 'Thai Baht',
      'IDR': 'Indonesian Rupiah',
      'MYR': 'Malaysian Ringgit',
      'PHP': 'Philippine Peso',
      'CZK': 'Czech Koruna',
      'ILS': 'Israeli Shekel',
      'AED': 'UAE Dirham',
      'SAR': 'Saudi Riyal',
      'RUB': 'Russian Ruble',
      'TRY': 'Turkish Lira',
    },
    this.historicalRates = const [],
    this.isLoadingHistory = false,
    this.multiCurrencyComparison = const {},
    this.showComparison = false,
  });

  CurrencyConverterState copyWith({
    String? baseCurrency,
    String? targetCurrency,
    double? amount,
    ExchangeRate? exchangeRate,
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? availableCurrencies,
    List<Map<String, dynamic>>? historicalRates,
    bool? isLoadingHistory,
    Map<String, double>? multiCurrencyComparison,
    bool? showComparison,
  }) {
    return CurrencyConverterState(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      amount: amount ?? this.amount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      historicalRates: historicalRates ?? this.historicalRates,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      multiCurrencyComparison: multiCurrencyComparison ?? this.multiCurrencyComparison,
      showComparison: showComparison ?? this.showComparison,
    );
  }
}

class CurrencyConverterController
    extends StateNotifier<CurrencyConverterState> {
  final CurrencyApiService _apiService;

  CurrencyConverterController(this._apiService)
      : super(const CurrencyConverterState()) {
    // Automatically convert on initialization
    convert();
    // Load historical rates
    loadHistoricalRates();
  }

  void setBaseCurrency(String currency) {
    state = state.copyWith(baseCurrency: currency);
    convert();
    loadHistoricalRates();
  }

  void setTargetCurrency(String currency) {
    state = state.copyWith(targetCurrency: currency);
    convert();
    loadHistoricalRates();
  }

  void setAmount(String amount) {
    final sanitized = amount.replaceAll(',', '').trim();
    final parsedAmount = double.tryParse(sanitized) ?? 0.0;
    state = state.copyWith(amount: parsedAmount);
    convert();
  }

  void swapCurrencies() {
    state = state.copyWith(
      baseCurrency: state.targetCurrency,
      targetCurrency: state.baseCurrency,
    );
    convert();
    loadHistoricalRates();
  }

  Future<void> convert() async {
    // Allow conversion even with amount 0 or less to show exchange rate
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final rate = await _apiService.getExchangeRate(
        state.baseCurrency,
        state.targetCurrency,
      );

      final exchangeRate = ConvertCurrency.convert(
        baseCurrency: state.baseCurrency,
        targetCurrency: state.targetCurrency,
        rate: rate,
        amount: state.amount,
      );

      state = state.copyWith(
        exchangeRate: exchangeRate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadHistoricalRates() async {
    state = state.copyWith(isLoadingHistory: true);

    try {
      final historicalData = await _apiService.getHistoricalRates(
        state.baseCurrency,
        state.targetCurrency,
        7, // Last 7 days
      );

      state = state.copyWith(
        historicalRates: historicalData,
        isLoadingHistory: false,
      );
    } catch (e) {
      state = state.copyWith(
        historicalRates: [],
        isLoadingHistory: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: '');
  }

  // NEW METHODS: Multi-currency comparison
  void toggleComparison() {
    state = state.copyWith(showComparison: !state.showComparison);
    if (state.showComparison) {
      loadMultiCurrencyComparison();
    }
  }

  Future<void> loadMultiCurrencyComparison() async {
    final comparisonCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'CNY'];
    final comparison = <String, double>{};

    try {
      for (final currency in comparisonCurrencies) {
        if (currency != state.baseCurrency) {
          final rate = await _apiService.getExchangeRate(
            state.baseCurrency,
            currency,
          );
          comparison[currency] = state.amount * rate;
        }
      }

      state = state.copyWith(multiCurrencyComparison: comparison);
    } catch (e) {
      // On error, use empty comparison
      state = state.copyWith(multiCurrencyComparison: {});
    }
  }
}

final currencyApiServiceProvider = Provider<CurrencyApiService>((ref) {
  return CurrencyApiService();
});

final currencyConverterProvider =
    StateNotifierProvider<CurrencyConverterController, CurrencyConverterState>(
  (ref) {
    final apiService = ref.read(currencyApiServiceProvider);
    return CurrencyConverterController(apiService);
  },
);
