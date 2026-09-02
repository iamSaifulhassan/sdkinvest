import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Renamed from the original 'sdk_theme_mode' — that key used to store a
// bool (light/dark only, no system option) via setBool. Reusing it with
// getString/setString would crash for anyone who still has that old bool
// value persisted (shared_preferences enforces the type per key), so this
// preference now lives under its own key instead of trying to migrate it.
const _prefsKey = 'sdk_theme_mode_v2';

/// App-wide light/dark preference. Provided once above the router (like
/// [AuthCubit]) since the theme applies to every screen, not just one.
///
/// Defaults to [ThemeMode.system] — the app follows the OS's light/dark
/// setting until the user explicitly picks one via [toggle], at which point
/// that explicit choice is persisted via [SharedPreferences] and wins from
/// then on, even if the OS setting changes.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved;
    try {
      saved = prefs.getString(_prefsKey);
    } catch (_) {
      // A value of the wrong type under this key (e.g. left over from a
      // future bug) shouldn't crash startup — just fall back to system.
      saved = null;
    }
    switch (saved) {
      case 'light':
        emit(ThemeMode.light);
      case 'dark':
        emit(ThemeMode.dark);
      // No saved value (or an unrecognized one) means no explicit choice
      // has been made yet — stay on the ThemeMode.system default.
    }
  }

  /// Flips to the opposite of whatever is currently showing. If the app is
  /// still following the system theme, this is the first explicit choice —
  /// from here on the picked mode is pinned and persisted.
  Future<void> toggle({required bool currentlyDark}) async {
    final next = currentlyDark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, next == ThemeMode.dark ? 'dark' : 'light');
  }
}
