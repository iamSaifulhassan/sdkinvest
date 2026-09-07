import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/support/faq_item.dart';
import '../../../data/support/faq_content.dart';
import '../../widgets/common/theme_toggle_button.dart';

/// Frequently Asked Questions — an accordion over [kFaqItems], with a
/// hand-off to Contact & Support for anything the list doesn't answer.
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'FAQ',
          style: AppTextStyles.headline.copyWith(fontSize: 20),
        ),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Text(
              'Frequently Asked Questions',
              style: AppTextStyles.title.copyWith(fontSize: 18, height: 1.35),
            ),
            const SizedBox(height: 4),
            Text(
              'Learn more about SDK Intelligent Investing.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < kFaqItems.length; i++) ...[
              if (i != 0) const SizedBox(height: AppSpacing.sm),
              _FaqTile(item: kFaqItems[i]),
            ],
            const SizedBox(height: AppSpacing.lg),
            const _StillNeedHelpCard(),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.item});

  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    // The card is a Material rather than a decorated Container: ExpansionTile
    // builds a ListTile, which paints its background and ink splash on the
    // nearest Material ancestor. Behind a BoxDecoration those effects are
    // invisible, and Flutter asserts about it in debug.
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: AppColors.border),
      ),
      // ExpansionTile draws its own top/bottom dividers when open, which
      // would cut across the card's rounded border — this hides them.
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 2,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: AppColors.accentBlue,
          collapsedIconColor: AppColors.textMuted,
          title: Text(
            item.question,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          children: [
            Text(
              item.answer,
              style: AppTextStyles.body.copyWith(fontSize: 13.5, height: 1.55),
            ),
          ],
        ),
      ),
    );
  }
}

class _StillNeedHelpCard extends StatelessWidget {
  const _StillNeedHelpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: 20,
            color: AppColors.accentBlue,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Still have questions?',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Reach the team through Contact & Support.',
                  style: AppTextStyles.caption.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.contactSupport),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Contact',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
