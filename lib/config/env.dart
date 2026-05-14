abstract class Env {
  static const String currencyApiKey = String.fromEnvironment(
    'CURRENCY_API_KEY',
    defaultValue: 'your_default_api_key_here',
  );

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
}
