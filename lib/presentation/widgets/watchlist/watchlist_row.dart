import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/watchlist/watchlist_item.dart';
import '../common/status_pill.dart';
import '../common/ticker_avatar.dart';

/// A single Watchlist row: ticker/name/price on the first line, SDK Score +
/// status pill + trailing signal (Near Buy zone / Score rising / Low
/// confidence) on the second.
class WatchlistRow extends StatelessWidget {
  const WatchlistRow({super.key, required this.item, this.onTap});

  final WatchlistItem item;
  final VoidCallback? onTap;

  static const double _avatarSize = 36;

  ({Color color, IconData icon}) get _indicatorVisual =>
      switch (item.indicator) {
        WatchlistIndicator.nearBuyZone => (
          color: AppColors.strongBuy,
          icon: Icons.arrow_circle_up_rounded,
        ),
        WatchlistIndicator.scoreRising => (
          color: AppColors.strongBuy,
          icon: Icons.arrow_circle_up_rounded,
        ),
        WatchlistIndicator.lowConfidence => (
          color: AppColors.hold,
          icon: Icons.remove_circle_outline_rounded,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final changeColor = item.isPositive ? AppColors.gain : AppColors.loss;
    final indicator = _indicatorVisual;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TickerAvatar(ticker: item.ticker, size: _avatarSize),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.ticker,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        item.name,
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: AppTextStyles.figure.copyWith(fontSize: 14),
                    ),
                    Text(
                      '${item.isPositive ? '+' : ''}${item.change.toStringAsFixed(2)} (${item.changePercent.toStringAsFixed(2)}%)',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${item.sdkScore}',
                      style: AppTextStyles.figure.copyWith(fontSize: 14),
                    ),
                    Text(
                      'SDK Score',
                      style: AppTextStyles.caption.copyWith(fontSize: 8.5),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: _avatarSize + AppSpacing.sm),
              child: Row(
                children: [
                  StatusPill(status: item.status),
                  const Spacer(),
                  Icon(indicator.icon, size: 13, color: indicator.color),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      item.indicator.label,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        color: indicator.color,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
