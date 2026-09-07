import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// The card-entry block on the checkout screen, laid out to match Stripe's
/// hosted Checkout page: card number, then expiry and CVC side by side.
///
/// **This is deliberately inert — do not turn these into `TextField`s.**
///
/// Card details must be collected by Stripe's own input widget, not by this
/// app. Stripe's `CardFormField` (from the `flutter_stripe` package) is a
/// native platform view that Stripe renders and reads; the primary account
/// number never passes through Dart, which is what keeps the app out of PCI
/// DSS scope. Replacing this widget with ordinary text fields would put the
/// raw card number in this app's memory, its logs, and its crash reports.
///
/// To make it live:
///   1. Add `flutter_stripe` to `pubspec.yaml`.
///   2. Set `Stripe.publishableKey` at startup from the publishable key.
///   3. Swap this widget for `CardFormField(onCardChanged: ...)`.
///   4. Have a backend create the SubscriptionIntent / PaymentIntent and
///      confirm it with the client secret — the secret key never ships in
///      the app.
class StripeCardFieldPlaceholder extends StatelessWidget {
  const StripeCardFieldPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card information', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        // IgnorePointer, not just "no controller": nothing here should be
        // focusable or typable, even by keyboard traversal.
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _FieldRow(
                  hint: '1234 1234 1234 1234',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.credit_card_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.border),
                Row(
                  children: [
                    const Expanded(child: _FieldRow(hint: 'MM / YY')),
                    Container(width: 1, height: 42, color: AppColors.border),
                    const Expanded(child: _FieldRow(hint: 'CVC')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 12,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                'Card details are entered in Stripe’s secure field. '
                'Connect the Stripe SDK to enable it.',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.hint, this.trailing});

  final String hint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 13,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              style: AppTextStyles.body.copyWith(
                fontSize: 13.5,
                color: AppColors.textMuted,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
