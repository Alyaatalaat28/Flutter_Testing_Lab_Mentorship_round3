import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('ShoppingCart Business Logic', () {
    test('CartItem calculations work correctly with discount', () {
      final item = CartItem(
        id: '1',
        name: 'Test Item',
        price: 100.0,
        quantity: 2,
        discount: 0.1, // 10%
      );

      expect(item.discountedPrice, 90.0);
      expect(item.discountAmount, 20.0);
      expect(item.totalPrice, 180.0);
    });

    test('CartItem calculations work correctly without discount', () {
      final item = CartItem(
        id: '1',
        name: 'Test Item',
        price: 50.0,
        quantity: 3,
        discount: 0.0,
      );

      expect(item.discountedPrice, 50.0);
      expect(item.discountAmount, 0.0);
      expect(item.totalPrice, 150.0);
    });

    test('CartItem with 100% discount results in zero cost', () {
      final item = CartItem(
        id: '1',
        name: 'Free Item',
        price: 100.0,
        quantity: 1,
        discount: 1.0, // 100%
      );

      expect(item.discountedPrice, 0.0);
      expect(item.discountAmount, 100.0);
      expect(item.totalPrice, 0.0);
    });
  });

  group('ShoppingCart Widget Tests', () {
    testWidgets('initially shows empty cart', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('adds an item and updates total', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      // Tap add iPhone button
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // Should now show 1 item
      expect(find.text('Total Items: 1'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsOneWidget);
    });

    testWidgets('adding duplicate item updates quantity', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      final addButton = find.text('Add iPhone');
      await tester.tap(addButton);
      await tester.tap(addButton);
      await tester.pump();

      // Should show quantity 2
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Total Items: 2'), findsOneWidget);
    });

    testWidgets('updates quantity using + and - buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // Should show quantity 1 initially
      expect(find.text('1'), findsOneWidget);

      // Increase quantity
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Decrease quantity
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('removes item when quantity reaches 0', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      // Should have one item
      expect(find.text('Samsung Galaxy'), findsOneWidget);

      // Decrease quantity to 0
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();

      // Item should be removed
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('removes item when delete button is pressed', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('clear cart button empties everything', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      await tester.tap(find.text('Add iPhone'));
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      expect(find.text('Total Items: 2'), findsOneWidget);

      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('shows discount when item has discount', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      await tester.tap(find.text('Add iPhone')); // Has 10% discount
      await tester.pump();

      // Should show discount text
      expect(find.text('Discount: 10%'), findsOneWidget);
    });
  });

  group('ShoppingCart Integration Tests', () {
    testWidgets('complete shopping flow works correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShoppingCart()));

      // Start with empty cart
      expect(find.text('Cart is empty'), findsOneWidget);

      // Add items
      await tester.tap(find.text('Add iPhone'));
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      // Verify items are added
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Samsung Galaxy'), findsOneWidget);
      expect(find.text('Total Items: 2'), findsOneWidget);

      // Update quantities
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      expect(find.text('2'), findsOneWidget); // iPhone quantity should be 2

      // Clear cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      // Back to empty
      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });
}