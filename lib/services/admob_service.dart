import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobTestIds {
  static const String banner = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewarded = 'ca-app-pub-3940256099942544/5224354917';
}

class AdmobService {
  AdmobService._();

  static final AdmobService instance = AdmobService._();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isLoadingInterstitial = false;
  bool _isLoadingRewarded = false;

  void preload() {
    loadInterstitial();
    loadRewarded();
  }

  void loadInterstitial() {
    if (_isLoadingInterstitial) {
      return;
    }
    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdmobTestIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoadingInterstitial = false;
        },
      ),
    );
  }

  bool showInterstitial() {
    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitial();
      return false;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
      },
    );
    ad.show();
    _interstitialAd = null;
    return true;
  }

  void loadRewarded() {
    if (_isLoadingRewarded) {
      return;
    }
    _isLoadingRewarded = true;
    RewardedAd.load(
      adUnitId: AdmobTestIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoadingRewarded = false;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isLoadingRewarded = false;
        },
      ),
    );
  }

  bool showRewarded({
    required void Function(RewardItem reward) onEarned,
  }) {
    final ad = _rewardedAd;
    if (ad == null) {
      loadRewarded();
      return false;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewarded();
      },
    );
    ad.show(onUserEarnedReward: (ad, reward) {
      onEarned(reward);
    });
    _rewardedAd = null;
    return true;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
