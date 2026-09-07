import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subscription/subscription_plan.dart';

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.cycle = BillingCycle.annual,
    this.plans = const [],
    this.selectedPlanName = 'Founding Member',
  });

  final BillingCycle cycle;
  final List<SubscriptionPlan> plans;

  /// Name of the plan card the user has tapped. Plans have no id of their
  /// own and their names are unique, so the name is the identity here.
  final String selectedPlanName;

  /// The tapped plan, or null if [selectedPlanName] matches nothing (only
  /// possible if the seeded plan list changes without this default).
  SubscriptionPlan? get selectedPlan {
    for (final plan in plans) {
      if (plan.name == selectedPlanName) return plan;
    }
    return null;
  }

  SubscriptionState copyWith({
    BillingCycle? cycle,
    List<SubscriptionPlan>? plans,
    String? selectedPlanName,
  }) {
    return SubscriptionState(
      cycle: cycle ?? this.cycle,
      plans: plans ?? this.plans,
      selectedPlanName: selectedPlanName ?? this.selectedPlanName,
    );
  }

  @override
  List<Object?> get props => [cycle, plans, selectedPlanName];
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
              monthlyAmountUsd: 0,
              annualAmountUsd: 0,
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
              monthlyAmountUsd: 19,
              annualAmountUsd: 16,
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
              monthlyAmountUsd: 16,
              annualAmountUsd: 149,
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

  void selectPlan(String planName) =>
      emit(state.copyWith(selectedPlanName: planName));
}
