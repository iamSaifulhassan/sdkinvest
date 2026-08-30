import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/subscription_plan.dart';
import '../widgets/app_feedback.dart';

/// Subscription screen — plan comparison + billing-cycle toggle + upgrade CTA.
/// Presented as a full-screen modal (closed via the leading X), matching the
/// mockup rather than living in the bottom-nav tab flow.
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  BillingCycle _cycle = BillingCycle.annual;

  static const _plans = [
    SubscriptionPlan(
      name: 'Free',
      monthlyPrice: '\$0',
      annualPrice: '\$0',
      billingNote: 'Get started',
      features: [
        'Real-time market data',
        'Watchlist with up to 10 symbols',
        'Daily market summary',
        'Limited stock research',
        'Community access',
      ],
    ),
    SubscriptionPlan(
      name: 'Basic',
      monthlyPrice: '\$19',
      annualPrice: '\$16',
      billingNote: 'Billed monthly',
      features: [
        'Everything in Free',
        'Watchlist with up to 100 symbols',
        'Advanced charts & technical indicators',
        'Stock screener & alerts',
        'Priority customer support',
      ],
    ),
    SubscriptionPlan(
      name: 'Founding Member',
      monthlyPrice: '\$16/mo',
      annualPrice: '\$149',
      billingNote: '/year',
      badgeLabel: 'RECOMMENDED',
      highlighted: true,
      savingsNote: 'You save \$79 vs. monthly',
      features: [
        'Everything in Basic',
        'Unlimited watchlist',
        'AI-powered stock insights',
        'Portfolio performance analytics',
        'Early access to new features',
      ],
    ),
  ];

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
        title: Text('Subscription', style: AppTextStyles.headline.copyWith(fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          children: [
            _BillingToggle(cycle: _cycle, onChanged: (c) => setState(() => _cycle = c)),
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < _plans.length; i++) ...[
              if (i != 0) const SizedBox(height: AppSpacing.md),
              _PlanCard(plan: _plans[i], cycle: _cycle),
            ],
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, size: 20, color: AppColors.strongBuy),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Current plan: Free', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('Upgrade anytime. Cancel anytime.', style: AppTextStyles.caption.copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: Text('Manage', style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => AppFeedback.showSnackBar(context, 'Free trial checkout is coming in a later phase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Start Free Trial', style: AppTextStyles.button.copyWith(fontSize: 15)),
                    Text(
                      '7-day free trial • Cancel anytime',
                      style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Secure payments. Auto-renewing subscriptions. You can manage or cancel anytime in Account Settings.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingToggle extends StatelessWidget {
  const _BillingToggle({required this.cycle, required this.onChanged});

  final BillingCycle cycle;
  final ValueChanged<BillingCycle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _ToggleOption(label: 'Monthly', caption: 'Pay monthly', selected: cycle == BillingCycle.monthly, onTap: () => onChanged(BillingCycle.monthly))),
          Expanded(child: _ToggleOption(label: 'Annual', caption: 'Pay yearly', selected: cycle == BillingCycle.annual, onTap: () => onChanged(BillingCycle.annual), badge: 'Best Value')),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({required this.label, required this.caption, required this.selected, required this.onTap, this.badge});

  final String label;
  final String caption;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentBlue.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: selected ? Border.all(color: AppColors.accentBlue) : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: selected ? AppColors.accentBlue : AppColors.textPrimary,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: AppColors.strongBuy, borderRadius: BorderRadius.circular(999)),
                    child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
            Text(caption, style: AppTextStyles.caption.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.cycle});

  final SubscriptionPlan plan;
  final BillingCycle cycle;

  @override
  Widget build(BuildContext context) {
    final price = cycle == BillingCycle.annual ? plan.annualPrice : plan.monthlyPrice;
    final priceSuffix = plan.name == 'Founding Member' && cycle == BillingCycle.annual ? plan.billingNote : (plan.name == 'Free' ? '' : '/month');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: plan.highlighted ? AppColors.accentBlue : AppColors.border, width: plan.highlighted ? 1.6 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(plan.name, style: AppTextStyles.title.copyWith(fontSize: 16)),
              ),
              if (plan.badgeLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.accentBlue, borderRadius: BorderRadius.circular(999)),
                  child: Text(plan.badgeLabel!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price, style: AppTextStyles.displayFigure.copyWith(fontSize: 26)),
              if (priceSuffix.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(priceSuffix, style: AppTextStyles.caption.copyWith(fontSize: 11)),
              ],
              const Spacer(),
              if (plan.savingsNote != null && cycle == BillingCycle.annual)
                Text(plan.savingsNote!, style: AppTextStyles.caption.copyWith(color: AppColors.strongBuy, fontSize: 10.5, fontWeight: FontWeight.w600))
              else
                Text(plan.billingNote, style: AppTextStyles.caption.copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final feature in plan.features)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: plan.highlighted ? AppColors.accentBlue : AppColors.strongBuy,
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(feature, style: AppTextStyles.caption.copyWith(fontSize: 12, color: AppColors.textPrimary))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
