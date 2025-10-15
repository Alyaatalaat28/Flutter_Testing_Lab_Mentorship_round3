import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('test shopping widget functionality', () {
    testWidgets('test add to cart', (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(home: ShoppingCart()));
      await widgetTester.tap(find.text('Add iPhone'));
      await widgetTester.pump();
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.textContaining('Items: 1'), findsOneWidget);
    });

    testWidgets('test no dublication and increase quantity', (
      widgetTester,
    ) async {
      await widgetTester.pumpWidget(const MaterialApp(home: ShoppingCart()));
      await widgetTester.tap(find.text('Add iPhone'));
      await widgetTester.pump();
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text("1"), findsOneWidget);
      await widgetTester.tap(find.text('Add iPhone'));
      await widgetTester.pump();
      expect(find.text("2"), findsOneWidget);
      expect(find.text("1"), findsNothing);
    });

    testWidgets('test empty cart', (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(home: ShoppingCart()));
      await widgetTester.tap(find.text('Add iPhone'));
      await widgetTester.pump();
      expect(find.text('Apple iPhone'), findsOneWidget);
      await widgetTester.tap(find.text('Clear'));
      await widgetTester.pump();
      expect(find.text('Your cart is empty!'), findsOneWidget);
    });
  });
}
