import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// "Rebalancing Insight" card on the Portfolio screen — a short suggestion
/// derived from the current allocation (e.g. "Consider trimming X...").
class RebalancingInsightCard extends StatelessWidget {
  const RebalancingInsightCard({super.key, required this.insight, this.onTap});

  final String insight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.strongBuy.withValues(alpha: 0.16),
                child: Icon(Icons.balance_rounded, size: 18, color: AppColors.strongBuy),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('Rebalancing Insight', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(width: 4),
                        Icon(Icons.info_outline_rounded, size: 12, color: AppColors.textMuted),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(insight, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
