import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/calculator/presentation/state/calculator_controller.dart';
import '../features/date_converter/presentation/state/date_converter_controller.dart';
import '../features/currency_converter/presentation/state/currency_controller.dart';
import '../features/currency_converter/data/remote/currency_api_service.dart';
import '../features/calculator/domain/models/calc_entry.dart';
import '../services/storage/hive_service.dart';
import '../services/api/http_client.dart';
import '../services/localization/l10n.dart';

// ============ THEME & SETTINGS PROVIDERS ============

/// Controls the app theme mode (light/dark/system)
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Controls the app language/locale
final localeProvider = StateProvider<String>((ref) => 'en');

/// Controls whether scientific mode is enabled in calculator
final scientificModeProvider = StateProvider<bool>((ref) => false);

/// Controls app font scale for accessibility
final fontSizeProvider = StateProvider<double>((ref) => 1.0);

// ============ FEATURE PROVIDERS ============

/// Calculator feature provider
final calculatorProvider =
    StateNotifierProvider<CalculatorController, CalculatorState>(
  (ref) => CalculatorController(),
);

/// Date converter feature provider
final dateConverterProvider =
    StateNotifierProvider<DateConverterController, DateConverterState>(
  (ref) => DateConverterController(),
);

/// Currency converter feature providers
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

// ============ SERVICE PROVIDERS ============

/// HTTP Client provider for API calls
final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient(baseUrl: 'https://api.exchangerate.host');
});

/// Hive storage service provider
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Localization service provider
final localizationProvider = Provider<AppLocalizations>((ref) {
  return AppLocalizations();
});

// ============ UTILITY PROVIDERS ============

/// Provider for app initialization status
final appInitializationProvider = FutureProvider<bool>((ref) async {
  // Initialize services here
  // await ref.read(hiveServiceProvider).init();
  return true;
});

/// Provider for network connectivity status
final connectivityProvider = StreamProvider<bool>((ref) async* {
  // This would integrate with connectivity_plus package
  // For now, return true as default
  yield true;
});

/// Provider for app version information
final appInfoProvider = Provider<Map<String, String>>((ref) {
  return {
    'version': '1.0.0',
    'buildNumber': '1',
    'name': 'MasterCalculator',
  };
});

// ============ FEATURE-SPECIFIC PROVIDERS ============

/// Provider for calculator history
final calculatorHistoryProvider = Provider<List<CalcEntry>>((ref) {
  final calculatorState = ref.watch(calculatorProvider);
  return calculatorState.history;
});

/// Provider for favorite currencies
final favoriteCurrenciesProvider =
    StateProvider<List<String>>((ref) => ['USD', 'EUR', 'NPR']);

/// Provider for conversion history
final conversionHistoryProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

// ============ SETTINGS PROVIDERS ============

/// Provider for app settings
final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) {
  return AppSettingsController();
});

class AppSettings {
  final bool isDarkMode;
  final String language;
  final bool isScientificMode;
  final double fontSizeScale;
  final List<String> favoriteCurrencies;

  const AppSettings({
    this.isDarkMode = false,
    this.language = 'en',
    this.isScientificMode = false,
    this.fontSizeScale = 1.0,
    this.favoriteCurrencies = const ['USD', 'EUR', 'NPR'],
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    bool? isScientificMode,
    double? fontSizeScale,
    List<String>? favoriteCurrencies,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isScientificMode: isScientificMode ?? this.isScientificMode,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      favoriteCurrencies: favoriteCurrencies ?? this.favoriteCurrencies,
    );
  }
}

class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController() : super(const AppSettings());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleScientificMode() {
    state = state.copyWith(isScientificMode: !state.isScientificMode);
  }

  void setFontSizeScale(double scale) {
    state = state.copyWith(fontSizeScale: scale.clamp(0.8, 2.0));
  }

  void addFavoriteCurrency(String currency) {
    if (!state.favoriteCurrencies.contains(currency)) {
      state = state.copyWith(
        favoriteCurrencies: [...state.favoriteCurrencies, currency],
      );
    }
  }

  void removeFavoriteCurrency(String currency) {
    state = state.copyWith(
      favoriteCurrencies:
          state.favoriteCurrencies.where((c) => c != currency).toList(),
    );
  }

  void resetToDefaults() {
    state = const AppSettings();
  }
}

// ============ SELECTORS ============

/// Selector for dark mode status
final isDarkModeSelector = Provider<bool>((ref) {
  return ref.watch(themeProvider) == ThemeMode.dark;
});

/// Selector for current conversion rate
final currentRateSelector = Provider<double?>((ref) {
  final currencyState = ref.watch(currencyConverterProvider);
  return currencyState.exchangeRate?.rate;
});

/// Selector for calculator display value
final calculatorDisplaySelector = Provider<String>((ref) {
  final calculatorState = ref.watch(calculatorProvider);
  return calculatorState.currentExpression.isEmpty
      ? calculatorState.result
      : calculatorState.currentExpression;
});
