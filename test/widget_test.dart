// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:salli_app/main.dart';

void main() {
  testWidgets('Salli app e2e test - Dashboard, SIP Calculator, Navigation', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SalliApp());
    await tester.pumpAndSettle();

    // Test 1: Verify app renders with Dashboard greeting
    expect(find.text('Ayubowan, Karan'), findsOneWidget);
    expect(find.text('Welcome back to Salli'), findsOneWidget);

    // Test 2: Verify balance card is displayed
    expect(find.text('Total Net Worth'), findsOneWidget);
    expect(find.text('LKR 1,250,000.00'), findsOneWidget);

    // Test 3: Verify quick actions are rendered
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Receive'), findsOneWidget);
    expect(find.text('Pay Bills'), findsOneWidget);

    // Test 4: Verify market overview data
    expect(find.text('CBSL Policy Rate'), findsOneWidget);
    expect(find.text('8.75%'), findsOneWidget);
    expect(find.text('Headline Inflation'), findsOneWidget);
    expect(find.text('5.5%'), findsOneWidget);

    // Test 5: Navigate to SIP Calculator tab
    await tester.tap(find.byIcon(Icons.auto_graph));
    await tester.pumpAndSettle();
    expect(find.text('SIP Calculator'), findsWidgets); // Multiple occurrences
    expect(find.text('Monthly Investment'), findsOneWidget);

    // Test 6: Verify SIP sliders exist
    expect(find.byType(Slider), findsWidgets);

    // Test 7: Navigate back to Dashboard
    await tester.tap(find.byIcon(Icons.space_dashboard));
    await tester.pumpAndSettle();
    expect(find.text('Ayubowan, Karan'), findsOneWidget);

    // Test 8: Navigate to Vault tab
    await tester.tap(find.byIcon(Icons.lock));
    await tester.pumpAndSettle();
    expect(find.text('Vault'), findsOneWidget);
  });
}
