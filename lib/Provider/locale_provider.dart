import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  static const _key = 'selected_language';

  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString(_key);
      if (lang != null && mounted) {
        state = Locale(lang);
      }
    } catch (_) {
      // Platform channels not ready (hot restart)
    }
  }

  Future<void> setLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, languageCode);
      state = Locale(languageCode);
    } catch (_) {
      // Platform channels not ready (hot restart)
    }
  }

  bool get hasSelectedLanguage => state != null;
}
