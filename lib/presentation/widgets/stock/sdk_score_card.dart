import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock.dart';
import '../common/status_pill.dart';

/// Headline SDK Score card: big score number, recommendation pill, and a
/// row of small meta chips (confidence, data coverage).
class SdkScoreCard extends StatelessWidget {
  const SdkScoreCard({
    super.key,
    required this.score,
    required this.status,
    required this.confidence,
    required this.dataCoverageLabel,
  });

  final int score;
  final StockStatus status;
  final StockConfidence confidence;
  final String dataCoverageLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SDK Score',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: AppTextStyles.displayFigure.copyWith(
                  fontSize: 68,
                  color: AppColors.strongBuy,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              StatusPill(status: status, large: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: 6,
              children: [
                _MetaChip(
                  dotColor: AppColors.textMuted,
                  filled: false,
                  label: confidence.label,
                ),
                const _MetaChip(
                  dotColor: AppColors.hold,
                  filled: true,
                  label: 'Low Confidence',
                ),
                _MetaChip(
                  dotColor: AppColors.accentBlue,
                  filled: true,
                  label: dataCoverageLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.dotColor,
    required this.filled,
    required this.label,
  });

  final Color dotColor;
  final bool filled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? dotColor : Colors.transparent,
            border: filled ? null : Border.all(color: dotColor, width: 1.3),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
      ],
    );
  }
}
