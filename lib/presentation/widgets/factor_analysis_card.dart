import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/factor_score.dart';

/// "6-Factor Analysis" card: a 3-column grid of bordered tiles, each with a
/// factor name, score (or "Missing"), and a thin progress bar.
class FactorAnalysisCard extends StatelessWidget {
  const FactorAnalysisCard({super.key, required this.factors});

  final List<FactorScore> factors;

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
              Text('6-Factor Analysis', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (var row = 0; row * 3 < factors.length; row++) ...[
            if (row != 0) const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var col = 0; col < 3; col++) ...[
                  if (col != 0) const SizedBox(width: AppSpacing.sm),
                  if (row * 3 + col < factors.length)
                    Expanded(child: _FactorTile(factor: factors[row * 3 + col]))
                  else
                    const Expanded(child: SizedBox.shrink()),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FactorTile extends StatelessWidget {
  const _FactorTile({required this.factor});

  final FactorScore factor;

  @override
  Widget build(BuildContext context) {
    final isMissing = factor.isMissing;
    final barColor = isMissing ? AppColors.hold : AppColors.strongBuy;
    final progress = isMissing ? 0.0 : (factor.value! / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            factor.label,
            style: AppTextStyles.caption.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            isMissing ? 'Missing' : '${factor.value}',
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              color: isMissing ? AppColors.hold : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: isMissing ? 1.0 : progress,
              minHeight: 4,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(isMissing ? AppColors.border : barColor),
            ),
          ),
        ],
      ),
    );
  }
}
