import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sdkinvest/data/models/auth/auth_user.dart';
import 'package:sdkinvest/data/models/subscription/subscription_plan.dart';
import 'package:sdkinvest/logic/auth/auth_cubit.dart';
import 'package:sdkinvest/logic/checkout/checkout_cubit.dart';
import 'package:sdkinvest/logic/theme/theme_cubit.dart';
import 'package:sdkinvest/presentation/pages/checkout/checkout_page.dart';
import 'package:sdkinvest/presentation/widgets/checkout/stripe_card_field_placeholder.dart';

const _foundingMember = SubscriptionPlan(
  name: 'Founding Member',
  monthlyPrice: '\$16/mo',
  annualPrice: '\$149',
  monthlyAmountUsd: 16,
  annualAmountUsd: 149,
  billingNote: '/year',
  features: ['Everything in Basic'],
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Widget wrap(Widget page) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit()
            ..signedIn(
              const AuthUser(name: 'Test User', email: 'test@example.com'),
            ),
        ),
      ],
      child: MaterialApp(home: page),
    );
  }

  Future<void> pumpCheckout(
    WidgetTester tester, {
    BillingCycle cycle = BillingCycle.annual,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      wrap(
        CheckoutPage(
          args: CheckoutArgs(plan: _foundingMember, cycle: cycle),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the selected plan and its price', (tester) async {
    await pumpCheckout(tester);

    expect(find.text('Subscribe to Founding Member'), findsOneWidget);
    expect(find.text('USD 149.00'), findsWidgets);
    expect(find.text('per year'), findsOneWidget);
    expect(find.text('Billed yearly'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('monthly cycle bills the monthly amount', (tester) async {
    await pumpCheckout(tester, cycle: BillingCycle.monthly);

    expect(find.text('USD 16.00'), findsWidgets);
    expect(find.text('per month'), findsOneWidget);
    expect(find.text('Billed monthly'), findsOneWidget);
  });

  testWidgets('currency toggle converts and shows the FX disclaimer', (
    tester,
  ) async {
    await pumpCheckout(tester);

    expect(find.textContaining('Charges will vary'), findsNothing);

    await tester.tap(find.text('PKR'));
    await tester.pumpAndSettle();

    // 149 USD at the quoted 288.7820 rate.
    expect(find.text('PKR 43,028.52'), findsWidgets);
    expect(find.textContaining('1 USD = 288.7820 PKR'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('email is prefilled from the signed-in account', (tester) async {
    await pumpCheckout(tester);

    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('card details cannot be typed into this app', (tester) async {
    await pumpCheckout(tester);

    expect(find.byType(StripeCardFieldPlaceholder), findsOneWidget);

    // The card block must contain no editable field: card data belongs to
    // Stripe's own input, never to a TextField in this app. If someone
    // swaps the placeholder for real fields, this fails.
    final editableInCardBlock = find.descendant(
      of: find.byType(StripeCardFieldPlaceholder),
      matching: find.byType(EditableText),
    );
    expect(editableInCardBlock, findsNothing);
  });

  test('formatMoney groups thousands and always shows two decimals', () {
    expect(formatMoney(149, 'USD'), 'USD 149.00');
    expect(formatMoney(43028.5180, 'PKR'), 'PKR 43,028.52');
    expect(formatMoney(5772.76, 'PKR'), 'PKR 5,772.76');
    expect(formatMoney(0, 'USD'), 'USD 0.00');
    expect(formatMoney(1234567.5, 'PKR'), 'PKR 1,234,567.50');
  });
}
