import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  PremiumService._();

  static const String _keyIsPremium = 'is_premium';

  static Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsPremium) ?? false;
  }

  static Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPremium, value);
  }
}
