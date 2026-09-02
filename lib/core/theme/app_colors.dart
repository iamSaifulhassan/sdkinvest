import 'package:flutter/material.dart';

/// Design tokens for the SDK Investing app, in both a dark-navy and a
/// light palette. Every color in the app is read through this class rather
/// than hardcoded, so [ThemeCubit] flipping [isDark] and forcing a full
/// widget-tree rebuild (see `main.dart`) is all it takes to re-theme every
/// screen — nothing outside this file should hardcode a color.
class AppColors {
  const AppColors._();

  /// Set by `main.dart` from [ThemeCubit]'s state before every rebuild.
  /// Deliberately mutable (not a const/final palette) so a single flip
  /// re-points every getter below without threading a palette object
  /// through every widget in the tree.
  static bool isDark = true;

  // ---------------------------------------------------------------------
  // App background
  // ---------------------------------------------------------------------

  /// App background.
  static Color get navyDeep => isDark ? const Color(0xff0a1626) : const Color(0xfff4f6fa);

  /// Cards/panels that sit directly on the background (hero card, stat
  /// pills, bottom nav).
  static Color get navyCard => isDark ? const Color(0xff132842) : const Color(0xffffffff);

  /// Elevated surface — dialogs, sheets.
  static Color get navyCardAlt => isDark ? const Color(0xff1a3455) : const Color(0xffeef1f7);

  /// Hairline borders on [navyCard]/[navyCardAlt].
  static Color get navyBorder => isDark ? const Color(0xff223753) : const Color(0xffe0e5ee);

  /// Light content cards (Top 5 list, Action Center, list rows) that float
  /// over the background.
  static Color get cream => isDark ? const Color(0xfff5f6f8) : const Color(0xffffffff);

  /// Hairline row dividers within [cream] cards.
  static Color get creamBorder => isDark ? const Color(0xffe7e9ee) : const Color(0xffe7e9ee);

  /// Primary text on the app background.
  static Color get white => isDark ? const Color(0xffffffff) : const Color(0xff17233a);

  /// Muted/secondary text on the app background.
  static Color get slate => isDark ? const Color(0xff8a97ab) : const Color(0xff64748b);

  /// Primary text on light [cream] cards — already dark-on-light in both
  /// themes, so it doesn't need to flip.
  static const Color ink = Color(0xff17233a);

  /// Muted/secondary text on light [cream] cards.
  static const Color inkMuted = Color(0xff6b7686);

  /// The interactive accent — active tab, links, primary CTAs. Constant
  /// across both themes so the brand color reads the same either way.
  static const Color accentBlue = Color(0xff3b7dfb);

  /// Secondary accent (cyan) — used for the ticker-avatar fallback palette
  /// and neutral "info" alert/price-zone icons.
  static const Color accentCyan = Color(0xff06b6d4);

  /// Tertiary accent (violet) — ticker-avatar fallback palette, "Other"
  /// allocation slice, and a couple of decorative icon colors.
  static const Color accentPurple = Color(0xff8b5cf6);

  /// Warm gold used for the light-mode ("sun") theme-toggle glyph, matching
  /// the reference design. Constant across both themes.
  static const Color gold = Color(0xfff5b942);

  // Semantic status colors, matching the SDK Score action pills. Constant
  // across themes — buy/sell meaning shouldn't shift with light/dark.
  static const Color strongBuy = Color(0xff1fae64);
  static const Color buy = Color(0xff34d399);
  static const Color hold = Color(0xfff5a524);
  static const Color trim = Color(0xffef4b4b);

  /// Positive figures / chart lines.
  static const Color gain = Color(0xff34d399);

  /// Negative figures.
  static const Color loss = Color(0xffef4b4b);

  static Color get background => navyDeep;
  static Color get surface => navyCard;
  static Color get surfaceAlt => navyCardAlt;
  static Color get border => navyBorder;
  static Color get textPrimary => white;
  static Color get textSecondary => white;
  static Color get textMuted => slate;
  static const Color primary = accentBlue;
  static const Color accent = accentBlue;
  static const Color success = gain;
  static const Color danger = loss;
}
