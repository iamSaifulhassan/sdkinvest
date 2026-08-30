import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/stock.dart';
import '../common/status_pill.dart';
import '../common/ticker_avatar.dart';

/// A single stock row (logo, ticker/name, SDK Score, status pill, confidence
/// tag) meant to sit inside a light cream card — e.g. Home's "Today's Top 5"
/// preview or the full Top 5 screen's ranked list.
///
/// Laid out as two lines rather than one wide row so it never has to squeeze
/// avatar + name + score + pill + confidence tag into a single line on
/// narrow phone widths.
class StockRowCard extends StatelessWidget {
  const StockRowCard({
    super.key,
    required this.stock,
    this.rank,
    this.onTap,
    this.showTagline = false,
  });

  final Stock stock;
  final int? rank;
  final VoidCallback? onTap;

  /// Show the one-line rationale (e.g. "Growth + Momentum leaders") under
  /// the status row. Only the full Top 5 ranked list has room for this.
  final bool showTagline;

  static const double _avatarSize = 36;
  double get _leadingWidth =>
      _avatarSize + AppSpacing.sm + (rank != null ? 20 : 0);

  @override
  Widget build(BuildContext context) {
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
                if (rank != null) ...[
                  SizedBox(
                    width: 16,
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                TickerAvatar(ticker: stock.ticker, size: _avatarSize),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stock.ticker,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        stock.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${stock.sdkScore}',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      'SDK Score',
                      style: TextStyle(color: AppColors.inkMuted, fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                SizedBox(width: _leadingWidth),
                StatusPill(status: stock.status),
                const Spacer(),
                Text(
                  stock.confidence.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 9),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 15,
                  color: AppColors.inkMuted,
                ),
              ],
            ),
            if (showTagline && stock.tagline != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: _leadingWidth),
                child: Text(
                  stock.tagline!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
