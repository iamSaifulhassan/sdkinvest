import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sdkinvest/data/legal/disclaimer_content.dart';
import 'package:sdkinvest/data/legal/privacy_policy_content.dart';
import 'package:sdkinvest/data/legal/terms_content.dart';
import 'package:sdkinvest/logic/theme/theme_cubit.dart';
import 'package:sdkinvest/presentation/pages/legal/legal_document_page.dart';
import 'package:sdkinvest/presentation/pages/support/contact_support_page.dart';
import 'package:sdkinvest/presentation/pages/support/faq_page.dart';

void main() {
  setUp(() {
    // Every one of these screens carries a ThemeToggleButton, whose
    // ThemeCubit restores its preference through SharedPreferences.
    SharedPreferences.setMockInitialValues({});
  });

  // Phone-width viewport so layout bugs that only show up on narrow screens
  // are caught here, matching widget_test.dart's convention.
  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// These pages sit under the app-wide [ThemeCubit] in `main.dart`, so they
  /// need it here too — pumping them bare only proves they fail without it.
  Widget wrap(Widget page) {
    return BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(),
      child: MaterialApp(home: page),
    );
  }

  testWidgets('FAQ renders and expands without framework exceptions', (
    WidgetTester tester,
  ) async {
    usePhoneViewport(tester);

    await tester.pumpWidget(wrap(const FaqPage()));
    await tester.pumpAndSettle();

    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(find.text('What is the SDK Score?'), findsOneWidget);

    // Regression: the FAQ card used to be a decorated Container, which hid
    // the background and ink that ExpansionTile's inner ListTile paints, and
    // tripped "ListTile background color or ink splashes may be invisible"
    // on every build. Expanding a tile is what exercised that path.
    await tester.tap(find.text('What is the SDK Score?'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('single composite score from 0 to 100'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Contact & Support renders both channels', (
    WidgetTester tester,
  ) async {
    usePhoneViewport(tester);

    await tester.pumpWidget(wrap(const ContactSupportPage()));
    await tester.pumpAndSettle();

    expect(find.text('Email Support'), findsOneWidget);
    expect(find.text('support@sdkinvesting.com'), findsOneWidget);
    expect(find.text('Live Chat'), findsOneWidget);
    expect(find.text('Coming Soon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Legal documents render end to end', (WidgetTester tester) async {
    usePhoneViewport(tester);

    for (final document in [
      kDisclaimerDocument,
      kTermsDocument,
      kPrivacyPolicyDocument,
    ]) {
      // Keyed per document: without this the next pumpWidget reuses the
      // same element tree, and the ListView keeps the scroll offset the
      // previous document was left at.
      await tester.pumpWidget(
        wrap(
          LegalDocumentPage(
            key: ValueKey(document.title),
            document: document,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(document.subtitle), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Scroll the whole document through the viewport so a section that
      // only fails to lay out further down still gets exercised.
      final listView = find.byType(Scrollable).first;
      for (var i = 0; i < 12; i++) {
        await tester.drag(listView, const Offset(0, -600));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });

  test('Disclaimer carries every clause from the source document', () {
    // 22 numbered clauses plus the unnumbered preamble.
    expect(kDisclaimerDocument.sections.length, 23);
    expect(kDisclaimerDocument.sections.first.number, isNull);
    expect(kDisclaimerDocument.sections.last.number, 22);
    expect(kDisclaimerDocument.effectiveDate, 'August 17, 2026');
  });
}
