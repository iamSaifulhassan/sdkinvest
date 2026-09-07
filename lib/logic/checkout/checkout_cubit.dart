import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subscription/subscription_plan.dart';

/// Currencies the checkout can display, matching the toggle on the web
/// version's Stripe Checkout page.
enum CheckoutCurrency { usd, pkr }

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.plan,
    required this.cycle,
    this.currency = CheckoutCurrency.usd,
    this.email = '',
    this.cardholderName = '',
    this.country = 'Pakistan',
  });

  final SubscriptionPlan plan;
  final BillingCycle cycle;
  final CheckoutCurrency currency;
  final String email;
  final String cardholderName;
  final String country;

  /// USD per 1 unit of the display currency's base — i.e. how many rupees a
  /// dollar buys.
  ///
  /// Hardcoded from the rate the live Stripe page quoted (1 USD = 288.7820
  /// PKR). A real integration must not do this: Stripe prices the
  /// subscription and returns the charged amount, because this rate moves
  /// and a stale one shows the user a figure they won't actually be billed.
  /// Replace this the moment the checkout session comes from a backend.
  static const double usdToPkr = 288.7820;

  double get amountUsd => plan.amountUsdFor(cycle);

  double get displayAmount =>
      currency == CheckoutCurrency.pkr ? amountUsd * usdToPkr : amountUsd;

  String get currencyCode => currency == CheckoutCurrency.pkr ? 'PKR' : 'USD';

  /// "per month" / "per year", matching how the plan is actually billed.
  String get periodLabel =>
      cycle == BillingCycle.annual ? 'per year' : 'per month';

  String get billingNote =>
      cycle == BillingCycle.annual ? 'Billed yearly' : 'Billed monthly';

  bool get isFree => amountUsd == 0;

  CheckoutState copyWith({
    CheckoutCurrency? currency,
    String? email,
    String? cardholderName,
    String? country,
  }) {
    return CheckoutState(
      plan: plan,
      cycle: cycle,
      currency: currency ?? this.currency,
      email: email ?? this.email,
      cardholderName: cardholderName ?? this.cardholderName,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [
    plan,
    cycle,
    currency,
    email,
    cardholderName,
    country,
  ];
}

/// Drives the checkout screen's currency toggle and billing-detail fields.
///
/// Deliberately holds no card data: card entry belongs to Stripe's own
/// widget, which keeps the number out of this app's memory entirely. This
/// cubit only owns the fields around it.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required SubscriptionPlan plan,
    required BillingCycle cycle,
    String initialEmail = '',
  }) : super(
         CheckoutState(
           plan: plan,
           cycle: cycle,
           email: initialEmail,
           // The live page defaults to PKR for a Pakistan-based account;
           // plans are priced in USD, so USD is the honest default until a
           // backend tells us the customer's billing country.
           currency: CheckoutCurrency.usd,
         ),
       );

  void setCurrency(CheckoutCurrency currency) =>
      emit(state.copyWith(currency: currency));

  void setEmail(String email) => emit(state.copyWith(email: email));

  void setCardholderName(String name) =>
      emit(state.copyWith(cardholderName: name));

  void setCountry(String country) => emit(state.copyWith(country: country));
}
