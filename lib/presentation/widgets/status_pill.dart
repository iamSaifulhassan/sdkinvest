import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/stock.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final StockStatus status;

  Color get _color => switch (status) {
        StockStatus.strongBuy => AppColors.strongBuy,
        StockStatus.buy => AppColors.buy,
        StockStatus.hold => AppColors.hold,
        StockStatus.trim => AppColors.trim,
      };

  String get _label => switch (status) {
        StockStatus.strongBuy => 'STRONG BUY',
        StockStatus.buy => 'BUY',
        StockStatus.hold => 'HOLD',
        StockStatus.trim => 'TRIM',
      };

  /// Only Strong Buy gets a solid fill; the rest are soft tints of their color.
  bool get _isSolid => status == StockStatus.strongBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isSolid ? _color : _color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(_label, style: AppTextStyles.badge.copyWith(color: _isSolid ? Colors.white : _color)),
    );
  }
}
