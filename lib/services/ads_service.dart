import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_config.dart';
import 'save_service.dart';

/// AdMob wrapper. Handles Rewarded, Interstitial, and Banner ads.
/// Uses Google's official test IDs by default — replace in AppConfig before launch.
class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isLoadingRewarded = false;
  bool _isLoadingInterstitial = false;

  bool get adsRemoved => SaveService.adsRemoved;

  void loadAds() {
    if (kIsWeb) return;
    _loadRewardedAd();
    _loadInterstitialAd();
  }

  void _loadRewardedAd() {
    if (_isLoadingRewarded || _rewardedAd != null) return;
    _isLoadingRewarded = true;
    RewardedAd.load(
      adUnitId: AppConfig.admobRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoadingRewarded = false;
        },
        onAdFailedToLoad: (err) {
          _rewardedAd = null;
          _isLoadingRewarded = false;
          debugPrint('Rewarded ad failed: ${err.message}');
        },
      ),
    );
  }

  void _loadInterstitialAd() {
    if (adsRemoved) return;
    if (_isLoadingInterstitial || _interstitialAd != null) return;
    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AppConfig.admobInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
          _isLoadingInterstitial = false;
          debugPrint('Interstitial failed: ${err.message}');
        },
      ),
    );
  }

  /// Show a rewarded ad. On reward, calls [onReward].
  void showRewardedAd({required VoidCallback onReward}) {
    if (kIsWeb || _rewardedAd == null) {
      // Fallback for web / not-loaded: grant reward anyway in dev mode
      if (kDebugMode) onReward();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (_, reward) => onReward());
  }

  /// Show an interstitial ad (skipped if user has removed ads).
  void showInterstitial() {
    if (kIsWeb || adsRemoved || _interstitialAd == null) return;
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
  }
}
