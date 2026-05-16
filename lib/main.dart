import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_config.dart';
import 'services/ads_service.dart';
import 'services/iap_service.dart';
import 'services/auth_service.dart';
import 'services/save_service.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Hide system UI for immersive game experience
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Init local storage
  await Hive.initFlutter();
  await SaveService.init();

  // Init Firebase (crash reporting + analytics)
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    debugPrint('Firebase init skipped: $e');
  }

  // Init Supabase (cloud DB + auth + storage)
  try {
    if (AppConfig.supabaseUrl != 'REPLACE_ME_SUPABASE_URL') {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
    }
  } catch (e) {
    debugPrint('Supabase init skipped: $e');
  }

  // Init AdMob (only on mobile, not web)
  if (!kIsWeb && AppConfig.enableAds) {
    try {
      await MobileAds.instance.initialize();
      AdsService.instance.loadAds();
    } catch (e) {
      debugPrint('AdMob init skipped: $e');
    }
  }

  // Init Google Play Billing
  if (!kIsWeb && AppConfig.enableIAP) {
    await IapService.instance.init();
  }

  // Init auth (anonymous guest by default)
  await AuthService.instance.init();

  runApp(const ProviderScope(child: IronFrontApp()));
}

class IronFrontApp extends StatelessWidget {
  const IronFrontApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iron Front: Last Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A5D23), // Military olive
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        fontFamily: 'RobotoMono',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
