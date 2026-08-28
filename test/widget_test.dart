import 'package:flutter_test/flutter_test.dart';

import 'package:sdkinvest/main.dart';

void main() {
  testWidgets('Widget showcase renders and navigates to placeholder detail', (WidgetTester tester) async {
    await tester.pumpWidget(const SdkInvestApp());

    expect(find.text('Widget Showcase'), findsOneWidget);
    expect(find.text('Primary Button'), findsOneWidget);

    await tester.tap(find.text('Tap to navigate to a second placeholder route'));
    await tester.pumpAndSettle();

    expect(find.text('Placeholder Detail'), findsOneWidget);
  });
}
