import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/subscription/subscription_plan.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/checkout/checkout_cubit.dart';
import '../../widgets/common/app_feedback.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/checkout/stripe_card_field_placeholder.dart';

/// Route arguments for [CheckoutPage] — which plan, on which billing cycle.
class CheckoutArgs {
  const CheckoutArgs({required this.plan, required this.cycle});

  final SubscriptionPlan plan;
  final BillingCycle cycle;
}

/// Stripe-style checkout, mirroring the hosted Checkout page the web version
/// hands off to: order summary, currency toggle, contact details, payment
/// method, and the subscribe CTA.
///
/// Card entry is [StripeCardFieldPlaceholder] rather than text fields — see
/// that widget for why, and for what replaces it.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.args});

  final CheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutCubit(
        plan: args.plan,
        cycle: args.cycle,
        initialEmail: context.read<AuthCubit>().state.user?.email ?? '',
      ),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  late final TextEditingController _emailController;
  final _nameController = TextEditingController();

  /// Billing countries offered in the dropdown. A real integration reads
  /// this from Stripe rather than shipping its own list.
  static const _countries = <String>[
    'Pakistan',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'United Arab Emirates',
    'India',
    'Germany',
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: context.read<CheckoutCubit>().state.email,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Text(
          'Checkout',
          style: AppTextStyles.headline.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            tooltip: 'Close',
            icon: Icon(Icons.close_rounded, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final cubit = context.read<CheckoutCubit>();
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                _MerchantHeader(),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Subscribe to ${state.plan.name}',
                  style: AppTextStyles.body.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        formatMoney(state.displayAmount, state.currencyCode),
                        style: AppTextStyles.displayFigure.copyWith(
                          fontSize: 28,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      state.periodLabel,
                      style: AppTextStyles.caption.copyWith(fontSize: 11.5),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _CurrencyToggle(
                  currency: state.currency,
                  onChanged: cubit.setCurrency,
                ),
                if (state.currency == CheckoutCurrency.pkr) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '1 USD = ${CheckoutState.usdToPkr.toStringAsFixed(4)} PKR. '
                    'Charges will vary based on exchange rates.',
                    style: AppTextStyles.caption.copyWith(fontSize: 10.5),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                _OrderLineItem(state: state),
                const SizedBox(height: AppSpacing.lg),
                const _WalletRow(),
                const SizedBox(height: AppSpacing.lg),
                _SectionLabel('Contact information'),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Email',
                  hint: 'email@example.com',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  onChanged: cubit.setEmail,
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionLabel('Payment method'),
                const SizedBox(height: AppSpacing.sm),
                const StripeCardFieldPlaceholder(),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Cardholder name',
                  hint: 'Full name on card',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.creditCardName],
                  onChanged: cubit.setCardholderName,
                ),
                const SizedBox(height: AppSpacing.md),
                _CountryDropdown(
                  value: state.country,
                  countries: _countries,
                  onChanged: cubit.setCountry,
                ),
                const SizedBox(height: AppSpacing.xl),
                _SubscribeButton(state: state),
                const SizedBox(height: AppSpacing.md),
                const _CheckoutFooter(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Formats an amount the way a checkout does: currency code, thousands
/// separators, two decimals. Written by hand because the app doesn't depend
/// on `intl` — swap in `NumberFormat.currency` if that ever changes.
String formatMoney(double amount, String currencyCode) {
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i != 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '$currencyCode $buffer.${parts[1]}';
}

class _MerchantHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(
            Icons.storefront_rounded,
            size: 16,
            color: AppColors.accentBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'SDK Investing System, LLC',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.title.copyWith(fontSize: 14));
  }
}

class _CurrencyToggle extends StatelessWidget {
  const _CurrencyToggle({required this.currency, required this.onChanged});

  final CheckoutCurrency currency;
  final ValueChanged<CheckoutCurrency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CurrencyOption(
            label: 'USD',
            selected: currency == CheckoutCurrency.usd,
            onTap: () => onChanged(CheckoutCurrency.usd),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _CurrencyOption(
            label: 'PKR',
            selected: currency == CheckoutCurrency.pkr,
            onTap: () => onChanged(CheckoutCurrency.pkr),
          ),
        ),
      ],
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  const _CurrencyOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.accentBlue.withValues(alpha: 0.12)
          : AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(
          color: selected ? AppColors.accentBlue : AppColors.border,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: selected ? AppColors.accentBlue : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderLineItem extends StatelessWidget {
  const _OrderLineItem({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  state.plan.name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                formatMoney(state.displayAmount, state.currencyCode),
                style: AppTextStyles.figure.copyWith(fontSize: 13.5),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            state.billingNote,
            style: AppTextStyles.caption.copyWith(fontSize: 11.5),
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total due today',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Text(
                formatMoney(state.displayAmount, state.currencyCode),
                style: AppTextStyles.figure.copyWith(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Apple Pay / Link, which Stripe's own sheet renders once the SDK is wired.
/// Shown dimmed and inert here so the layout matches the real page without
/// implying a wallet button that does nothing is ready to use.
class _WalletRow extends StatelessWidget {
  const _WalletRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: 0.55,
          child: Row(
            children: [
              Expanded(child: _WalletButton(label: 'Apple Pay')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _WalletButton(label: 'Link')),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Wallet payments appear here once the Stripe SDK is connected.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(fontSize: 10.5),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                'OR',
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
      ],
    );
  }
}

class _WalletButton extends StatelessWidget {
  const _WalletButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  const _CountryDropdown({
    required this.value,
    required this.countries,
    required this.onChanged,
  });

  final String value;
  final List<String> countries;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Country or region', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: AppColors.surfaceAlt,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textMuted,
          ),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          items: [
            for (final country in countries)
              DropdownMenuItem(value: country, child: Text(country)),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}

/// The CTA. Disabled on purpose: with no Stripe SDK and no backend to create
/// a subscription, an enabled "Subscribe" button could only lie about having
/// taken a payment.
class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => AppFeedback.showSnackBar(
              context,
              'Connect the Stripe SDK and a backend to take payments.',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue.withValues(alpha: 0.45),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Text(
              'Subscribe',
              style: AppTextStyles.button.copyWith(fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'By subscribing, you authorize SDK Investing System, LLC to charge '
          'you ${formatMoney(state.displayAmount, state.currencyCode)} '
          '${state.periodLabel}, according to the terms, until you cancel.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(fontSize: 10.5, height: 1.45),
        ),
      ],
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 13,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 5),
            Text(
              'Powered by Stripe',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(label: 'Terms', route: AppRoutes.terms),
            Text('  •  ', style: AppTextStyles.caption.copyWith(fontSize: 11)),
            _FooterLink(label: 'Privacy', route: AppRoutes.privacyPolicy),
          ],
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(route),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontSize: 11,
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
