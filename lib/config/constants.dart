class AppConstants {
  static const String appName = 'Master Calculator';

  // API URLs - using free exchangerate-api.com (no key required for basic usage)
  static const String currencyBaseUrl = 'https://api.exchangerate-api.com/v4';

  // Storage keys
  static const String calcHistoryBox = 'calc_history';
  static const String currencyCacheBox = 'currency_cache';
  static const String settingsBox = 'app_settings';
}

class CalcConstants {
  static const List<String> scientificFunctions = [
    'sin',
    'cos',
    'tan',
    'log',
    'ln',
    'sqrt',
    '^',
    'π',
    'e',
  ];
}
