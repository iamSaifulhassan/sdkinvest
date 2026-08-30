import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock/stock.dart';

/// Shared color/label mapping for [StockStatus], so every screen that needs
/// a status color or a readable label (not just the [StatusPill] badge
/// itself — e.g. a table cell) stays in sync with one definition.
extension StockStatusVisuals on StockStatus {
  Color get pillColor => switch (this) {
    StockStatus.strongBuy => AppColors.strongBuy,
    StockStatus.buy => AppColors.buy,
    StockStatus.hold => AppColors.hold,
    StockStatus.trim => AppColors.trim,
  };

  /// ALL CAPS, for the pill badge itself.
  String get shoutLabel => switch (this) {
    StockStatus.strongBuy => 'STRONG BUY',
    StockStatus.buy => 'BUY',
    StockStatus.hold => 'HOLD',
    StockStatus.trim => 'TRIM',
  };

  /// Title Case, for plain-text placements (table cells, list rows).
  String get titleLabel => switch (this) {
    StockStatus.strongBuy => 'Strong Buy',
    StockStatus.buy => 'Buy',
    StockStatus.hold => 'Hold',
    StockStatus.trim => 'Trim',
  };
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, this.large = false});

  final StockStatus status;

  /// Scaled-up variant for headline placements (e.g. the Stock Detail
  /// SDK Score card) where the default badge size reads too small.
  final bool large;

  /// Only Strong Buy gets a solid fill; the rest are soft tints of their color.
  bool get _isSolid => status == StockStatus.strongBuy;

  @override
  Widget build(BuildContext context) {
    final color = status.pillColor;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 8,
        vertical: large ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: _isSolid ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.shoutLabel,
        style: AppTextStyles.badge.copyWith(
          color: _isSolid ? Colors.white : color,
          fontSize: large ? 14 : 10,
        ),
      ),
    );
  }
}
