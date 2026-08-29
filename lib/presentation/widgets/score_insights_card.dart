import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/score_insight.dart';

/// Card of bulleted insights — used for both "Why this score?" (positive,
/// green check) and "Material Missing Factors" (warning, amber icon).
class ScoreInsightsCard extends StatelessWidget {
  const ScoreInsightsCard({
    super.key,
    required this.title,
    required this.insights,
    this.isWarning = false,
    this.icon,
  });

  final String title;
  final List<ScoreInsight> insights;
  final bool isWarning;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final accentColor = isWarning ? AppColors.hold : AppColors.strongBuy;
    final leadingIcon = icon ?? (isWarning ? Icons.warning_amber_rounded : Icons.check_circle_rounded);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < insights.length; i++) ...[
            if (i != 0) const SizedBox(height: AppSpacing.md),
            _InsightRow(insight: insights[i], icon: insights[i].icon ?? leadingIcon, color: accentColor),
          ],
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.insight, required this.icon, required this.color});

  final ScoreInsight insight;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: color.withValues(alpha: 0.16),
          child: Icon(icon, size: 12, color: color),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(insight.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 2),
              Text(insight.detail, style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
            ],
          ),
        ),
      ],
    );
  }
}
