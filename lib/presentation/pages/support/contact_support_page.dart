import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_feedback.dart';
import '../../widgets/common/theme_toggle_button.dart';

/// Contact & Support — the support channels, mirroring
/// sdkinvesting.com/contact.
class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  static const String supportEmail = 'support@sdkinvesting.com';

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
          'Contact & Support',
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
              "We're here to help.",
              style: AppTextStyles.title.copyWith(fontSize: 18, height: 1.35),
            ),
            const SizedBox(height: 4),
            Text(
              'Reach out to us for any questions or issues.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ChannelCard(
              icon: Icons.mail_outline_rounded,
              title: 'Email Support',
              description:
                  "Send us an email and we'll get back to you within 24 hours.",
              child: _EmailRow(email: supportEmail),
            ),
            const SizedBox(height: AppSpacing.md),
            _ChannelCard(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Live Chat',
              description:
                  'Live chat support is not available yet. Please use email '
                  'support for assistance.',
              badge: 'Coming Soon',
              enabled: false,
            ),
            const SizedBox(height: AppSpacing.lg),
            _FaqHintCard(),
          ],
        ),
      ),
    );
  }
}

/// One support channel. [enabled] false dims the card so an unavailable
/// channel reads as unavailable rather than merely unlabelled.
class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.icon,
    required this.title,
    required this.description,
    this.badge,
    this.enabled = true,
    this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? badge;
  final bool enabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Container(
        width: double.infinity,
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
                Icon(
                  icon,
                  size: 18,
                  color: enabled ? AppColors.accentBlue : AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.title.copyWith(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.hold.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge!,
                      style: AppTextStyles.badge.copyWith(
                        fontSize: 9.5,
                        color: AppColors.hold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTextStyles.body.copyWith(fontSize: 13.5, height: 1.5),
            ),
            if (child != null) ...[
              const SizedBox(height: AppSpacing.md),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}

/// The support address. Tapping copies it to the clipboard — the app has no
/// URL-launcher dependency, so this works everywhere rather than depending
/// on a mail client being installed and reachable.
class _EmailRow extends StatelessWidget {
  const _EmailRow({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    // Material carries the fill and border rather than a BoxDecoration, so
    // the InkWell's ripple paints above the background instead of behind it.
    return Material(
      color: AppColors.accentBlue.withValues(alpha: 0.10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: AppColors.accentBlue.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: email));
          if (!context.mounted) return;
          AppFeedback.showSnackBar(context, 'Support email copied.');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  email,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.accentBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.copy_rounded, size: 16, color: AppColors.accentBlue),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqHintCard extends StatelessWidget {
  const _FaqHintCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.quiz_outlined, size: 18, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Check the FAQ first — it may already answer your question.',
                  style: AppTextStyles.caption.copyWith(fontSize: 12.5),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
