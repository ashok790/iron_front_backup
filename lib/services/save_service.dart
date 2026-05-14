import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence for game progress, settings, and entitlements.
/// Uses SharedPreferences for simplicity; can be swapped for Hive later.
class SaveService {
  static late SharedPreferences _prefs;

  static const _kCoins = 'coins';
  static const _kHighestWave = 'highest_wave';
  static const _kSubscribed = 'subscribed';
  static const _kAdsRemoved = 'ads_removed';
  static const _kBattlePass = 'battle_pass';
  static const _kSoundOn = 'sound_on';
  static const _kMusicOn = 'music_on';
  static const _kGuestId = 'guest_id';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------- Currency ----------
  static int get coins => _prefs.getInt(_kCoins) ?? 0;
  static Future<void> addCoins(int amount) async =>
      _prefs.setInt(_kCoins, coins + amount);
  static Future<void> spendCoins(int amount) async =>
      _prefs.setInt(_kCoins, (coins - amount).clamp(0, 999999));

  // ---------- Progress ----------
  static int get highestWave => _prefs.getInt(_kHighestWave) ?? 0;
  static Future<void> setHighestWave(int wave) async {
    if (wave > highestWave) await _prefs.setInt(_kHighestWave, wave);
  }

  // ---------- Entitlements ----------
  static bool get isSubscribed => _prefs.getBool(_kSubscribed) ?? false;
  static Future<void> setSubscribed(bool v) async => _prefs.setBool(_kSubscribed, v);

  static bool get adsRemoved => _prefs.getBool(_kAdsRemoved) ?? false;
  static Future<void> setAdsRemoved(bool v) async => _prefs.setBool(_kAdsRemoved, v);

  static bool get battlePassOwned => _prefs.getBool(_kBattlePass) ?? false;
  static Future<void> setBattlePassOwned(bool v) async => _prefs.setBool(_kBattlePass, v);

  // ---------- Settings ----------
  static bool get soundOn => _prefs.getBool(_kSoundOn) ?? true;
  static Future<void> setSoundOn(bool v) async => _prefs.setBool(_kSoundOn, v);

  static bool get musicOn => _prefs.getBool(_kMusicOn) ?? true;
  static Future<void> setMusicOn(bool v) async => _prefs.setBool(_kMusicOn, v);

  // ---------- Guest ID ----------
  static String? get guestId => _prefs.getString(_kGuestId);
  static Future<void> setGuestId(String id) async => _prefs.setString(_kGuestId, id);
}
