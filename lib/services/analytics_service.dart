import 'package:flutter/foundation.dart';

// Analytics service for tracking user interactions
class AnalyticsService {
  static void logEvent(String eventName, [Map<String, dynamic>? parameters]) {
    // Integrate with Firebase Analytics or similar service
    debugPrint('Analytics Event: $eventName - $parameters');
  }

  static void logScreenView(String screenName) {
    logEvent('screen_view', {'screen_name': screenName});
  }

  static void logButtonTap(String buttonName) {
    logEvent('button_tap', {'button_name': buttonName});
  }

  static void logConversion(String from, String to) {
    logEvent('conversion', {'from': from, 'to': to});
  }
}
