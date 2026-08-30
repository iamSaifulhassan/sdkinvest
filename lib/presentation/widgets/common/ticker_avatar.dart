import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Placeholder stock "logo" — a tinted initials circle derived from the
/// ticker. Swap for real brand logo assets once an image pipeline exists.
class TickerAvatar extends StatelessWidget {
  const TickerAvatar({super.key, required this.ticker, this.size = 36});

  final String ticker;
  final double size;

  static const _palette = [
    AppColors.accent,
    AppColors.strongBuy,
    AppColors.hold,
    AppColors.accentPurple,
    AppColors.accentCyan,
  ];

  /// Rough brand-color approximations for tickers that show up in the
  /// mockups, so avatars read closer to the real logos than the generic
  /// hash-based palette below.
  static const _brandColors = <String, Color>{
    'NVDA': Color(0xff76b900),
    'MU': Color(0xff1c75bc),
    'MSFT': Color(0xff5e5e5e),
    'VRT': Color(0xff0a0a0a),
    'AAPL': Color(0xff555555),
    'XOM': Color(0xffd0122a),
    'CVX': Color(0xff0055a4),
  };

  Color get _bg =>
      _brandColors[ticker] ?? _palette[ticker.hashCode.abs() % _palette.length];

  @override
  Widget build(BuildContext context) {
    final initials = ticker.length >= 2 ? ticker.substring(0, 2) : ticker;
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _bg.withValues(alpha: 0.16),
      child: Text(
        initials,
        style: TextStyle(
          color: _bg,
          fontSize: size * 0.32,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
