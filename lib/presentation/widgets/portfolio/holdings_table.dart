import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/holding.dart';
import '../common/status_pill.dart';
import '../common/ticker_avatar.dart';

/// "Holding / Position Value / Weight / SDK Score / Action" data table for
/// the Portfolio screen.
class HoldingsTable extends StatelessWidget {
  const HoldingsTable({super.key, required this.holdings});

  final List<Holding> holdings;

  @override
  Widget build(BuildContext context) {
    final headerStyle = AppTextStyles.caption.copyWith(
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.3),
          3: FlexColumnWidth(1.3),
          4: FlexColumnWidth(1.6),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Holding', style: headerStyle),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Value',
                  textAlign: TextAlign.right,
                  style: headerStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Weight',
                  textAlign: TextAlign.right,
                  style: headerStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Score',
                  textAlign: TextAlign.right,
                  style: headerStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Action',
                  textAlign: TextAlign.right,
                  style: headerStyle,
                ),
              ),
            ],
          ),
          for (final holding in holdings)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      TickerAvatar(ticker: holding.ticker, size: 26),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              holding.ticker,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              holding.name,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 9.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    holding.positionValue,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${holding.weightPercent.toStringAsFixed(1)}%',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${holding.sdkScore}',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: holding.status.pillColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: StatusPill(status: holding.status),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
