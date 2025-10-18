import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('ShoppingCart Tests', () {
    testWidgets('should display empty cart initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text(r'Subtotal: $0.00'), findsOneWidget);
    });

    group('Adding Items', () {
      testWidgets('should add item to cart', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();

        expect(find.text('Cart is empty'), findsNothing);
        expect(find.text('Apple iPhone'), findsOneWidget);
        expect(find.text('Total Items: 1'), findsOneWidget);
      });

      testWidgets('should increment quantity when adding duplicate item',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add iPhone Again'));
        await tester.pumpAndSettle();

        // Should show quantity 2, not 2 separate entries
        expect(find.text('2'), findsOneWidget);
        expect(find.widgetWithText(Card, 'Apple iPhone'), findsOneWidget);
        expect(find.text('Total Items: 2'), findsOneWidget);
      });

      testWidgets('should add multiple different items',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add Galaxy'));
        await tester.pumpAndSettle();

        expect(find.text('Apple iPhone'), findsOneWidget);
        expect(find.text('Samsung Galaxy'), findsOneWidget);
        expect(find.text('Total Items: 2'), findsOneWidget);
      });
    });

    group('Removing Items', () {
      testWidgets('should remove item with delete button',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithIcon(IconButton, Icons.delete));
        await tester.pumpAndSettle();

        expect(find.text('Cart is empty'), findsOneWidget);
      });

      testWidgets('should remove item when quantity reaches 0',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithIcon(IconButton, Icons.remove).first);
        await tester.pumpAndSettle();

        expect(find.text('Cart is empty'), findsOneWidget);
      });

      testWidgets('should clear all items', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add Galaxy'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Clear Cart'));
        await tester.pumpAndSettle();

        expect(find.text('Cart is empty'), findsOneWidget);
        expect(find.text('Total Items: 0'), findsOneWidget);
      });
    });

    group('Quantity Updates', () {
      testWidgets('should increase quantity with + button',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithIcon(IconButton, Icons.add).first);
        await tester.pumpAndSettle();

        expect(find.text('2'), findsWidgets);
        expect(find.text('Total Items: 2'), findsOneWidget);
      });

      testWidgets('should decrease quantity with - button',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithIcon(IconButton, Icons.add).first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithIcon(IconButton, Icons.remove).first);
        await tester.pumpAndSettle();

        expect(find.text('1'), findsWidgets);
        expect(find.text('Total Items: 1'), findsOneWidget);
      });
    });

    group('Price Calculations', () {
      testWidgets('should calculate subtotal correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();

        expect(find.text(r'Subtotal: $999.99'), findsOneWidget);
      });

      testWidgets('should calculate discount correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        // iPhone has 10% discount on $999.99 = $100.00
        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();

        expect(find.text(r'Total Discount: $100.00'), findsOneWidget);
      });

      testWidgets('should calculate total as subtotal minus discount',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        // iPhone: $999.99 - $100.00 discount = $899.99
        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();

        expect(find.text(r'Subtotal: $999.99'), findsOneWidget);
        expect(find.text(r'Total Discount: $100.00'), findsOneWidget);
        expect(find.text(r'Total Amount: $899.99'), findsOneWidget);
      });

      testWidgets('should handle items without discount',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPad'));
        await tester.pumpAndSettle();

        expect(find.text(r'Total Discount: $0.00'), findsOneWidget);
        expect(find.text(r'Subtotal: $1099.99'), findsOneWidget);
        expect(find.text(r'Total Amount: $1099.99'), findsOneWidget);
      });

      testWidgets('should calculate discount with quantity',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        // Add 2 iPhones: $999.99 * 0.1 * 2 = $200.00 discount
        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add iPhone Again'));
        await tester.pumpAndSettle();

        expect(find.text(r'Total Discount: $200.00'), findsOneWidget);
      });

      testWidgets('should calculate totals with multiple items',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShoppingCart())),
        );

        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add Galaxy'));
        await tester.pumpAndSettle();

        // Subtotal: $999.99 + $899.99 = $1899.98
        expect(find.text(r'Subtotal: $1899.98'), findsOneWidget);
        // Discount: $100.00 + $135.00 = $235.00
        expect(find.text(r'Total Discount: $235.00'), findsOneWidget);
        // Total: $1899.98 - $235.00 = $1664.98
        expect(find.text(r'Total Amount: $1664.98'), findsOneWidget);
      });
    });
  });
}
