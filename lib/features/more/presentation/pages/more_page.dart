import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../unit_converter/presentation/pages/unit_converter_page.dart';
import '../../../loan_calculator/presentation/pages/loan_calculator_page.dart';
import '../../../percentage_calculator/presentation/pages/percentage_calculator_page.dart';
import '../../../scientific_calculator/presentation/pages/scientific_calculator_page.dart';
import '../../../number_system_converter/presentation/pages/number_system_converter_page.dart';
import '../../../temperature_converter/presentation/pages/temperature_converter_page.dart';
import '../../../ocr_calculator/presentation/pages/ocr_calculator_page.dart';
import '../../../../core/widgets/glassmorphic_widgets.dart';
import '../../../../services/admob_service.dart';
import '../../../../core/providers.dart';
import '../../../../services/premium_service.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Text(
            'More Tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GlassmorphicCard(
            blurValue: 12,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remove Ads (Premium)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPremium
                            ? 'Ads are disabled on this device.'
                            : 'Unlock an ad-free experience.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () async {
                    final newValue = !isPremium;
                    await PremiumService.setPremium(newValue);
                    ref.read(premiumProvider.notifier).state = newValue;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            newValue
                                ? 'Premium enabled. Ads removed.'
                                : 'Premium disabled. Ads restored.',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(isPremium ? 'Restore Ads' : 'Remove Ads'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Financial Tools'),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.payment,
            title: 'Loan / EMI Calculator',
            subtitle: 'Calculate monthly EMI & total interest',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanCalculatorPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.trending_up,
            title: 'Percentage & Profit',
            subtitle: 'Discount, Profit/Loss, GST calculator',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PercentageCalculatorPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Other Tools'),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.calculate,
            title: 'Advanced Scientific Calculator',
            subtitle: 'Trig, log, sqrt, factorial & constants',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScientificCalculatorPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.straighten,
            title: 'Unit Converter',
            subtitle: 'Convert between different units',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Unit Converter'),
                    ),
                    body: const UnitConverterPage(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Converter Tools'),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.code,
            title: 'Number System Converter',
            subtitle: 'Convert between binary, octal, decimal, hex',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NumberSystemConverterPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.thermostat,
            title: 'Temperature Converter',
            subtitle: 'Convert between Celsius, Fahrenheit, Kelvin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemperatureConverterPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.image_search,
            title: 'OCR Calculator',
            subtitle: 'Scan math expressions from images',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OCRCalculatorPage(),
                ),
              );
            },
          ),
          if (kDebugMode && !isPremium) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'AdMob Test (Debug)'),
            const SizedBox(height: 12),
            GlassmorphicCard(
              blurValue: 12,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Interstitial and Rewarded Ads',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final shown =
                                AdmobService.instance.showInterstitial();
                            if (!shown) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Interstitial not ready yet'),
                                ),
                              );
                            }
                          },
                          child: const Text('Show Interstitial'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final shown =
                                AdmobService.instance.showRewarded(
                              onEarned: (reward) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Reward earned: ${reward.amount} ${reward.type}',
                                    ),
                                  ),
                                );
                              },
                            );
                            if (!shown) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Rewarded not ready yet'),
                                ),
                              );
                            }
                          },
                          child: const Text('Show Rewarded'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return GlassmorphicContainer(
      blurValue: 8,
      opacity: 0.06,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      borderRadius: BorderRadius.circular(16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GlassmorphicCard(
      blurValue: 12,
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withValues(alpha: 0.3),
                  primaryColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: primaryColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
