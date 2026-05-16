# 🛡️ Iron Front: Last Defense

A military-themed tower defense game built with **Flutter** + **Flame engine** + **Supabase**.

This is a **production-ready code foundation**. To launch on Google Play, you must:
1. Set up your free accounts (see "API Setup" below)
2. Replace placeholder keys in `lib/config/app_config.dart`
3. Build & sign the APK/AAB
4. Submit to Play Console

---

## 📦 What's Included

✅ Complete Flutter project structure
✅ Working tower defense game (3 towers, 4 enemy types, 15 waves, scaling difficulty)
✅ AdMob integration (rewarded + interstitial ads) — uses Google test IDs by default
✅ Google Play Billing (subscriptions + IAP) — Monthly $2.99, Yearly $24.99, Remove Ads $3.99, Coin packs
✅ Supabase auth + cloud save schema (SQL included)
✅ Firebase Crashlytics + Analytics hooks
✅ Google Sign-In integration
✅ Local save with SharedPreferences
✅ Full menu system: Splash → Home → Game → Shop → Subscription → Settings
✅ Production AndroidManifest.xml with all required permissions
✅ Gradle build configured for release

---

## 🔑 API Setup (All Free Tier)

Sign up for these services (in order) and copy the keys into `lib/config/app_config.dart`:

### 1. Google Play Console — $25 one-time (mandatory)
- URL: https://play.google.com/console
- Required to publish ANY Android app. Pay $25, verify identity, add bank info.

### 2. Supabase — Free
- URL: https://supabase.com → "New Project"
- Open your project → Settings → API
- Copy `URL` → paste into `supabaseUrl`
- Copy `anon public key` → paste into `supabaseAnonKey`
- Open SQL Editor, paste & run the contents of `supabase/schema.sql`

### 3. Firebase — Free
- URL: https://console.firebase.google.com → "Add project"
- Add Android app with package name `com.ironfront.lastdefense`
- Download `google-services.json` → place in `android/app/`
- Uncomment the firebase plugin lines in `android/app/build.gradle`

### 4. AdMob — Free (you earn money from this)
- URL: https://admob.google.com → "Apps" → "Add app"
- Get App ID → replace in `AndroidManifest.xml` (line 19) and `AppConfig.admobAppIdAndroid`
- Create ad units: Rewarded, Interstitial, Banner → paste IDs into AppConfig
- **Keep test IDs during development!** Replace only before submitting to Play.

### 5. Google Sign-In — Free
- URL: https://console.cloud.google.com → APIs & Services → Credentials
- Create OAuth 2.0 Client ID (Android type)
- SHA-1 fingerprint of your release keystore required (see "Signing" below)

---

## 💰 Subscription Products Setup (Play Console)

In Play Console → Monetize → Subscriptions, create:

| Product ID | Type | Price | Description |
|---|---|---|---|
| `commanders_pass_monthly` | Subscription | $2.99/mo | Ad-free + 2× coins + skins |
| `commanders_pass_yearly` | Subscription | $24.99/yr | Same + bonus skin |
| `remove_ads` | In-app product | $3.99 | One-time ad removal |
| `coins_1000` | In-app product | $0.99 | 1,000 coins |
| `coins_5000` | In-app product | $4.99 | 5,000 coins |
| `battle_pass_season1` | In-app product | $4.99 | Battle pass |

---

## 🚀 Build & Run

### Prerequisites
Install Flutter SDK: https://docs.flutter.dev/get-started/install

### Run locally (web preview)
```bash
flutter pub get
flutter run -d chrome
```

### Build Android APK (for testing on phone)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build Android AAB (for Play Store upload)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 🔐 Signing the App for Release

1. Generate keystore (DO THIS ONCE, BACK IT UP!):
```bash
keytool -genkey -v -keystore ~/iron-front-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias iron-front
```

2. Create `android/key.properties`:
```
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=iron-front
storeFile=/Users/you/iron-front-key.jks
```

3. Edit `android/app/build.gradle` — in `buildTypes.release`, change `signingConfig signingConfigs.debug` to `signingConfig signingConfigs.release`

⚠️ **NEVER commit `key.properties` or `.jks` to git.** Add to `.gitignore`.
⚠️ **If you lose the keystore, you can never update your app.** Back it up to multiple safe places.

---

## 📤 Publishing to Play Store

1. Create app listing in Play Console
2. Upload AAB to "Internal testing" track first
3. Add store listing: title, description, screenshots (min 2), feature graphic (1024×500), 512×512 icon
4. Complete content rating questionnaire
5. Complete data safety form (you collect: device ID, app analytics)
6. Submit for review (typically 1-7 days)
7. After approval, promote to Production

---

## ⚠️ Honest Notes

- **First-day earnings**: Expect $0. Most indie games earn $0–$5 in their first month.
- **Marketing matters more than code.** Without ads/marketing, your game won't get downloads.
- **Test ads use Google's test IDs** so they always show but don't earn money. Only switch to real IDs RIGHT before publishing.
- **Replay testing is critical.** Run on a real Android device before publishing.

---

## 📁 Project Structure

```
iron_front/
├── lib/
│   ├── main.dart                    # Entry point, init Firebase/Supabase/Ads/IAP
│   ├── config/
│   │   └── app_config.dart          # ⚠️ REPLACE_ME placeholders
│   ├── game/
│   │   ├── game_engine.dart         # Flame game loop, waves, economy
│   │   └── components/              # Enemies, towers, projectiles, path
│   ├── models/                      # Tower & enemy data
│   ├── screens/                     # Splash, Home, Game, Shop, Subscription, Settings
│   ├── services/                    # Ads, IAP, Auth, Save
│   └── widgets/                     # Reusable HUD widgets
├── android/
│   └── app/
│       ├── build.gradle             # AdMob + Billing deps
│       └── src/main/AndroidManifest.xml
├── supabase/
│   └── schema.sql                   # Run in Supabase SQL Editor
├── pubspec.yaml                     # Dependencies
└── README.md
```

---

## 🆘 If You Can't Code

This codebase is intentionally clean and well-organized so a freelance Flutter developer can finish/polish it for you:

- **Fiverr/Upwork search terms**: "Flutter game developer", "AdMob integration", "Google Play publish"
- **Typical cost to polish + publish**: $500–$3000 USD
- **What to ask the developer**:
  1. Replace placeholder keys with real ones
  2. Add real artwork (or buy from gamedev marketplaces)
  3. Test on real devices
  4. Sign and upload to Play Store
  5. (Optional) Add more levels and content

---

Built with ❤️ using Flutter, Flame, and Supabase.
