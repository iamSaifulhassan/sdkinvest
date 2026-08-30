import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// "Master the SDK System" hero card at the top of the Academy screen: a
/// headline, a progress bar, and a small ascending Sell/Trim/Hold/Buy
/// staircase illustration.
class AcademyHeroCard extends StatelessWidget {
  const AcademyHeroCard({super.key, required this.progressPercent});

  final int progressPercent;

  static const _steps = [
    (label: 'BUY', color: AppColors.strongBuy, height: 28.0),
    (label: 'HOLD', color: AppColors.hold, height: 44.0),
    (label: 'TRIM', color: Color(0xffdb7a1f), height: 60.0),
    (label: 'SELL', color: AppColors.trim, height: 76.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.strongBuy.withValues(alpha: 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Master the',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'SDK System',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Learn when to Buy, Hold, Trim, and Sell.',
                  style: AppTextStyles.caption.copyWith(fontSize: 12.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$progressPercent% complete',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.strongBuy,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progressPercent / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.strongBuy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final step in _steps)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Container(
                    width: 20,
                    height: step.height,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                      color: step.color.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        step.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
