import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/app_config.dart';
import 'save_service.dart';

/// Wraps Supabase auth. Supports Google Sign-In + Guest mode.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  String? _guestId;
  String? get userId {
    try {
      final u = Supabase.instance.client.auth.currentUser;
      return u?.id ?? _guestId;
    } catch (_) {
      return _guestId;
    }
  }

  Future<void> init() async {
    _guestId = SaveService.guestId;
    if (_guestId == null) {
      _guestId = const Uuid().v4();
      await SaveService.setGuestId(_guestId!);
    }
  }

  bool get isSignedIn {
    try {
      return Supabase.instance.client.auth.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    if (AppConfig.supabaseUrl == 'REPLACE_ME_SUPABASE_URL') {
      debugPrint('Supabase not configured — skipping Google sign-in');
      return;
    }
    try {
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
  }
}
