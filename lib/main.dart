import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';
import 'core/providers.dart';
import 'services/premium_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  final isPremium = await PremiumService.load();

  // Initialize services
  // await Hive.initFlutter();
  // await HiveService.init();

  runApp(
    ProviderScope(
      overrides: [
        premiumProvider.overrideWith((ref) => isPremium),
      ],
      child: MasterCalculatorApp(),
    ),
  );
}
