/// =====================================================================
/// IRON FRONT: LAST DEFENSE — APP CONFIGURATION
/// =====================================================================
/// REPLACE EVERY VALUE BELOW MARKED `REPLACE_ME` WITH YOUR OWN KEYS.
/// You get these keys from the dashboards after you sign up for each
/// service. See README.md for step-by-step signup instructions.
/// =====================================================================
class AppConfig {
  // ---------- SUPABASE ----------
  // Get from: https://app.supabase.com → Your Project → Settings → API
  static const String supabaseUrl = 'REPLACE_ME_SUPABASE_URL';
  static const String supabaseAnonKey = 'REPLACE_ME_SUPABASE_ANON_KEY';

  // ---------- GOOGLE ADMOB ----------
  // Get from: https://admob.google.com → Apps → App Settings
  // Use TEST IDs during development. Replace with REAL IDs only before
  // publishing to Play Store (or you violate AdMob policy).
  static const String admobAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713'; // Google's official test App ID
  static const String admobRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String admobInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String admobBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID

  // ---------- GOOGLE PLAY BILLING (Subscriptions / IAP) ----------
  // Create these product IDs in: Google Play Console → Monetize → Subscriptions / In-app products
  static const String subMonthlyId = 'commanders_pass_monthly';   // $2.99/mo
  static const String subYearlyId = 'commanders_pass_yearly';    // $24.99/yr
  static const String iapRemoveAds = 'remove_ads';               // $3.99
  static const String iapCoins1000 = 'coins_1000';               // $0.99
  static const String iapCoins5000 = 'coins_5000';               // $4.99
  static const String iapBattlePass = 'battle_pass_season1';     // $4.99

  // ---------- GOOGLE SIGN-IN ----------
  // Get from: https://console.cloud.google.com → APIs & Services → Credentials
  // (Not needed for Android if google-services.json is configured; needed for Web)
  static const String googleSignInWebClientId = 'REPLACE_ME_WEB_CLIENT_ID.apps.googleusercontent.com';

  // ---------- GAME BALANCE ----------
  static const int startingCoins = 200;
  static const int startingLives = 20;
  static const int totalLevels = 300;
  static const int unitsPerSquad = 9;
  static const int enemyTypeCount = 8;

  // ---------- FEATURE FLAGS ----------
  static const bool enableAds = true;
  static const bool enableIAP = true;
  static const bool enableCloudSync = true;
  static const bool debugShowFPS = false;
}
