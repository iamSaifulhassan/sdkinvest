import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

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
    Color(0xff8b5cf6),
    Color(0xff06b6d4),
  ];

  Color get _bg => _palette[ticker.hashCode.abs() % _palette.length];

  @override
  Widget build(BuildContext context) {
    final initials = ticker.length >= 2 ? ticker.substring(0, 2) : ticker;
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _bg.withValues(alpha: 0.16),
      child: Text(
        initials,
        style: TextStyle(color: _bg, fontSize: size * 0.32, fontWeight: FontWeight.w800),
      ),
    );
  }
}
