import 'package:flutter/material.dart';

/// Design tokens extracted from the SDK Investing mockups (design-system
/// PDF: Home, Stock Detail, Top 5, Portfolio, Watchlist, Compare, Alerts,
/// Academy, Subscription). Deep navy app chrome with light content cards
/// for data lists, plus color-coded action pills (Strong Buy/Buy/Hold/Trim).
/// Nothing outside this file should hardcode a color.
class AppColors {
  const AppColors._();

  /// App background — deep navy, near-black.
  static const Color navyDeep = Color(0xff0a1626);

  /// Cards/panels that sit directly on the navy background (hero card,
  /// stat pills, bottom nav).
  static const Color navyCard = Color(0xff132842);

  /// Elevated surface on navy — dialogs, sheets.
  static const Color navyCardAlt = Color(0xff1a3455);

  /// Hairline borders on dark cards.
  static const Color navyBorder = Color(0xff223753);

  /// Light content cards (Top 5 list, Action Center, list rows) that float
  /// over the dark background.
  static const Color cream = Color(0xfff5f6f8);

  /// Hairline row dividers within cream cards.
  static const Color creamBorder = Color(0xffe7e9ee);

  /// Primary text on the navy background.
  static const Color white = Color(0xffffffff);

  /// Muted/secondary text on the navy background.
  static const Color slate = Color(0xff8a97ab);

  /// Primary text on light cream cards.
  static const Color ink = Color(0xff17233a);

  /// Muted/secondary text on light cream cards.
  static const Color inkMuted = Color(0xff6b7686);

  /// The interactive accent — active tab, links, primary CTAs.
  static const Color accentBlue = Color(0xff3b7dfb);

  /// Secondary accent (cyan) — used for the ticker-avatar fallback palette
  /// and neutral "info" alert/price-zone icons.
  static const Color accentCyan = Color(0xff06b6d4);

  /// Tertiary accent (violet) — ticker-avatar fallback palette, "Other"
  /// allocation slice, and a couple of decorative icon colors.
  static const Color accentPurple = Color(0xff8b5cf6);

  // Semantic status colors, matching the SDK Score action pills.
  static const Color strongBuy = Color(0xff1fae64);
  static const Color buy = Color(0xff34d399);
  static const Color hold = Color(0xfff5a524);
  static const Color trim = Color(0xffef4b4b);

  /// Positive figures / chart lines.
  static const Color gain = Color(0xff34d399);

  /// Negative figures.
  static const Color loss = Color(0xffef4b4b);

  static const Color background = navyDeep;
  static const Color surface = navyCard;
  static const Color surfaceAlt = navyCardAlt;
  static const Color border = navyBorder;
  static const Color textPrimary = white;
  static const Color textSecondary = white;
  static const Color textMuted = slate;
  static const Color primary = accentBlue;
  static const Color accent = accentBlue;
  static const Color success = gain;
  static const Color danger = loss;
}
