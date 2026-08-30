import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'brand_icons.dart';

enum SocialProvider { google, apple }

/// Outlined "Continue with Google/Apple" button, using each brand's real
/// logo mark (see brand_icons.dart) rather than a generic icon-font
/// approximation — Google's guidelines require the exact multi-color "G",
/// and a wrong glyph is one of the fastest ways an auth screen reads as a
/// template rather than a real product. No OAuth wired up yet — [onPressed]
/// is expected to show a "coming soon" message, same placeholder
/// convention used elsewhere in this app for unbuilt features.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  final SocialProvider provider;
  final VoidCallback onPressed;

  String get _label => switch (provider) {
    SocialProvider.google => 'Continue with Google',
    SocialProvider.apple => 'Continue with Apple',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            switch (provider) {
              SocialProvider.google => const GoogleLogo(size: 18),
              SocialProvider.apple => AppleLogo(
                size: 18,
                color: AppColors.textPrimary,
              ),
            },
            const SizedBox(width: AppSpacing.sm),
            Text(
              _label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
