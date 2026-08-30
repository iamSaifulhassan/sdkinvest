import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/alert_item.dart';
import 'status_pill.dart';

/// A single row on the Alerts & Signals list: leading category icon,
/// headline + company name + reason, trailing recommendation pill and
/// relative timestamp.
class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert});

  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: alert.iconColor.withValues(alpha: 0.16),
            child: Icon(alert.icon, size: 18, color: alert.iconColor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                    if (alert.status != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      StatusPill(status: alert.status!),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(alert.companyName, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Reason: ', style: AppTextStyles.caption.copyWith(fontSize: 12)),
                      TextSpan(text: alert.reason, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(alert.timeAgo, style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
