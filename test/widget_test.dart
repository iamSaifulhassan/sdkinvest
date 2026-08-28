import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sdkinvest/main.dart';

void main() {
  testWidgets("Home renders Today's Top 5 and navigates to Top 5 and Stock Detail", (WidgetTester tester) async {
    // Phone-width viewport so layout bugs that only show up on narrow
    // screens (e.g. row overflow) are caught here, not just at desktop width.
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SdkInvestApp());
    await tester.pumpAndSettle();

    // Home loaded via HomeCubit's mock data.
    expect(find.text('SDK'), findsOneWidget);
    expect(find.text('Good morning, Dr. Khan'), findsOneWidget);
    expect(find.text("Today's Top 5"), findsOneWidget);
    expect(find.text('Action Center'), findsOneWidget);
    expect(find.text('NVDA'), findsOneWidget);

    // Bottom nav takes us to Top 5.
    await tester.tap(find.byIcon(Icons.star_outline_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Top 5'), findsWidgets);
    expect(find.text('NVDA'), findsOneWidget);

    // Tapping a ranked stock card navigates to the Stock Detail placeholder.
    await tester.tap(find.text('NVDA'));
    await tester.pumpAndSettle();

    expect(find.text('Placeholder Detail'), findsOneWidget);

    await tester.tap(find.text('Go Back'));
    await tester.pumpAndSettle();

    // Back on Top 5, the bottom nav returns us to Home.
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Good morning, Dr. Khan'), findsOneWidget);

    // Tapping an out-of-scope tab surfaces a "coming soon" message rather
    // than silently doing nothing.
    await tester.tap(find.byIcon(Icons.pie_chart_outline_rounded));
    await tester.pumpAndSettle();

    expect(find.textContaining('coming in a later phase'), findsOneWidget);
  });
}
