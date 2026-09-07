import 'package:equatable/equatable.dart';

enum BillingCycle { monthly, annual }

/// One pricing tier on the Subscription screen.
class SubscriptionPlan extends Equatable {
  const SubscriptionPlan({
    required this.name,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.monthlyAmountUsd,
    required this.annualAmountUsd,
    required this.billingNote,
    required this.features,
    this.badgeLabel,
    this.highlighted = false,
    this.savingsNote,
  });

  final String name;
  final String monthlyPrice;
  final String annualPrice;

  /// The same figures [monthlyPrice]/[annualPrice] display, as numbers the
  /// checkout screen can convert between currencies. Display strings stay
  /// authoritative for what the user sees on the plan cards; these exist so
  /// the amount doesn't have to be parsed back out of them.
  final double monthlyAmountUsd;
  final double annualAmountUsd;

  double amountUsdFor(BillingCycle cycle) =>
      cycle == BillingCycle.annual ? annualAmountUsd : monthlyAmountUsd;

  /// Small trailing note under the price, e.g. "Billed monthly" or "Get started".
  final String billingNote;
  final List<String> features;

  /// "Best Value" / "RECOMMENDED" badge. Null hides the badge.
  final String? badgeLabel;

  /// Founding Member gets the accent border treatment.
  final bool highlighted;

  /// e.g. "You save \$79 vs. monthly" — shown only on the annual cycle.
  final String? savingsNote;

  @override
  List<Object?> get props => [
    name,
    monthlyPrice,
    annualPrice,
    monthlyAmountUsd,
    annualAmountUsd,
    billingNote,
    features,
    badgeLabel,
    highlighted,
    savingsNote,
  ];
}
