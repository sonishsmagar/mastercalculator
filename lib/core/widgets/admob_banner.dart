import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers.dart';
import '../../services/admob_service.dart';

class AdmobBanner extends ConsumerStatefulWidget {
  const AdmobBanner({super.key});

  @override
  ConsumerState<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends ConsumerState<AdmobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  ProviderSubscription<bool>? _premiumSub;

  @override
  void initState() {
    super.initState();
    _premiumSub = ref.listenManual<bool>(premiumProvider, (previous, next) {
      if (next) {
        _bannerAd?.dispose();
        _bannerAd = null;
        if (mounted) {
          setState(() {
            _isLoaded = false;
          });
        }
      } else {
        _loadBanner();
      }
    });
    _loadBanner();
  }

  void _loadBanner() {
    if (ref.read(premiumProvider)) {
      return;
    }
    _bannerAd = BannerAd(
      adUnitId: AdmobTestIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _premiumSub?.close();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumProvider);
    if (isPremium) {
      return const SizedBox.shrink();
    }
    final ad = _bannerAd;
    if (!_isLoaded || ad == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: ad.size.height.toDouble(),
      width: ad.size.width.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
