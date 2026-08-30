import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/home/home_action_item.dart';

/// One tinted tile inside Home's Action Center card.
class ActionItemTile extends StatelessWidget {
  const ActionItemTile({super.key, required this.item});

  final HomeActionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: item.accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, color: item.accentColor, size: 18),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.title,
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.timeAgo,
            style: TextStyle(color: AppColors.inkMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
