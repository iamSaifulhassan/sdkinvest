import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subscription/subscription_plan.dart';

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.cycle = BillingCycle.annual,
    this.plans = const [],
  });

  final BillingCycle cycle;
  final List<SubscriptionPlan> plans;

  SubscriptionState copyWith({
    BillingCycle? cycle,
    List<SubscriptionPlan>? plans,
  }) {
    return SubscriptionState(
      cycle: cycle ?? this.cycle,
      plans: plans ?? this.plans,
    );
  }

  @override
  List<Object?> get props => [cycle, plans];
}

/// Drives the Subscription screen's billing-cycle toggle. Plan data is
/// static (not user data), so it's seeded directly rather than pulled
/// through a repository — there's nothing else in the app that duplicates it.
class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit()
    : super(
        const SubscriptionState(
          plans: [
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
          ],
        ),
      );

  void setCycle(BillingCycle cycle) => emit(state.copyWith(cycle: cycle));
}
