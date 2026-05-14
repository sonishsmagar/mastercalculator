import 'package:flutter/material.dart';

class AppLocalizations {
  static const supportedLocales = [
    Locale('en', ''),
    Locale('ne', ''),
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'MasterCalculator',
      'calculator': 'Calculator',
      'dateConverter': 'Date Converter',
      'currencyConverter': 'Currency Converter',
      'convert': 'Convert',
      'clear': 'Clear',
      'error': 'Error',
      'success': 'Success',
    },
    'ne': {
      'appTitle': 'मास्टरक्याल्कुलेटर',
      'calculator': 'क्याल्कुलेटर',
      'dateConverter': 'मिति रूपान्तरण',
      'currencyConverter': 'मुद्रा रूपान्तरण',
      'convert': 'रूपान्तरण गर्नुहोस्',
      'clear': 'खाली गर्नुहोस्',
      'error': 'त्रुटि',
      'success': 'सफल',
    },
  };

  static String getString(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }
}
