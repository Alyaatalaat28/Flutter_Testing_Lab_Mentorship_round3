import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

// IMPORTANT: Replace with the actual path to your ShoppingCart file

void main() {
  // A standard wrapper function for running the widget test
  Future<void> pumpCartWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(8.0), child: ShoppingCart()),
          ),
        ),
      ),
    );
  }

  group('ShoppingCart Widget Interaction Tests', () {
    testWidgets('Initial state displays "Cart is empty" and totals are zero', (
      tester,
    ) async {
      await pumpCartWidget(tester);

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.textContaining('Subtotal: \$0.00'), findsOneWidget);
      expect(find.textContaining('Total Amount: \$0.00'), findsOneWidget);
    });

    testWidgets('Adding an item updates the UI totals correctly', (
      tester,
    ) async {
      await pumpCartWidget(tester);

      // Add iPhone (Price: 999.99, Discount: 0.1)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // Calculation:
      // Subtotal: 999.99
      // Discount: 99.999 (Rounds to 100.00 for display)
      // Total: 999.99 - 99.999 = 899.991 (Rounds to 899.99 for display)

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Total Items: 1'), findsOneWidget);

      // ✅ FIX 1: Use 899.99 as it's the correctly rounded total amount
      expect(find.textContaining('Subtotal: \$999.99'), findsOneWidget);
      expect(find.textContaining('Total Discount: -\$100.00'), findsOneWidget);
      expect(find.textContaining('Total Amount: \$899.99'), findsOneWidget);
    });

    testWidgets(
      'Tapping "Add iPhone Again" increments quantity and updates totals',
      (tester) async {
        await pumpCartWidget(tester);

        // 1. Add iPhone once (Qty 1)
        await tester.tap(find.text('Add iPhone'));
        await tester.pump();

        // 2. Add iPhone again (Qty 2)
        await tester.tap(find.text('Add iPhone Again'));
        await tester.pump();

        // Calculation (Qty 2):
        // Subtotal: 999.99 * 2 = 1999.98
        // Discount: 199.998 (Rounds to 200.00)
        // Total: 1999.98 - 199.998 = 1799.982 (Rounds to 1799.98)

        expect(find.text('2'), findsOneWidget);
        expect(find.textContaining('Total Items: 2'), findsOneWidget);

        // ✅ FIX 2: Use 1999.98 (no comma) and 1799.98 (correctly rounded)
        expect(find.textContaining('Subtotal: \$1999.98'), findsOneWidget);
        expect(
          find.textContaining('Total Discount: -\$200.00'),
          findsOneWidget,
        );
        expect(find.textContaining('Total Amount: \$1799.98'), findsOneWidget);

        // Verify item list displays final item total: (999.99 - 99.999) * 2 = 1799.98
        expect(find.textContaining('Item Total: \$1799.98'), findsOneWidget);
      },
    );

    testWidgets('Quantity buttons update item count and totals', (
      tester,
    ) async {
      await pumpCartWidget(tester);
      await tester.tap(
        find.text('Add iPad'),
      ); // Item 3, Qty 1, Price 1099.99, Discount 0.0
      await tester.pump();

      // Find the add button
      final addButtonFinder = find.byIcon(Icons.add);

      // Tap add button (Qty 1 -> Qty 2)
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Total Amount: 1099.99 * 2 = 2199.98
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Total Items: 2'), findsOneWidget);
      expect(find.textContaining('Total Amount: \$2199.98'), findsOneWidget);
    });

    testWidgets('Decrementing quantity to zero removes the item (Edge Case)', (
      tester,
    ) async {
      await pumpCartWidget(tester);

      // Add item (Qty 1)
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // Find the remove button
      final removeButtonFinder = find.byIcon(Icons.remove);

      // Tap remove button (Qty 1 -> Qty 0, should remove)
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      // Verify item is gone and cart is empty
      expect(find.text('iPad Pro'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.textContaining('Total Amount: \$0.00'), findsOneWidget);
    });

    testWidgets('Clear Cart button removes all items and resets totals', (
      tester,
    ) async {
      await pumpCartWidget(tester);

      // Add multiple items
      await tester.tap(find.text('Add iPhone'));
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();
      expect(find.byType(ListTile), findsNWidgets(2));

      // Tap Clear Cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      // Verify all items are gone and totals are reset
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.textContaining('Total Amount: \$0.00'), findsOneWidget);
    });
  });
}
