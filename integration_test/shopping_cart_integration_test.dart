import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/feature/shop_feature/shopping_cart.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to build the widget
  Future<void> buildWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShoppingCart(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Shopping Cart Integration Tests', () {
    testWidgets('Complete shopping flow - add, update, and checkout',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Verify initial empty state
          expect(find.text('Cart is empty'), findsOneWidget);
          expect(find.text('Total Items: 0'), findsOneWidget);

          // Add iPhone
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          expect(find.text('Apple iPhone'), findsOneWidget);
          expect(find.text('Total Items: 1'), findsOneWidget);

          // Add Galaxy
          await tester.tap(find.text('Add Galaxy'));
          await tester.pumpAndSettle();

          expect(find.text('Samsung Galaxy'), findsOneWidget);
          expect(find.text('Total Items: 2'), findsOneWidget);

          // Increase iPhone quantity
          final addButtons = find.byIcon(Icons.add);
          await tester.tap(addButtons.first);
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 3'), findsOneWidget);

          // Verify calculations
          expect(find.textContaining('Subtotal:'), findsOneWidget);
          expect(find.textContaining('Total Discount:'), findsOneWidget);
          expect(find.textContaining('Total Amount:'), findsOneWidget);
        });

    testWidgets('Add multiple quantities of same item',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add iPhone multiple times
          for (int i = 0; i < 5; i++) {
            await tester.tap(find.text('Add iPhone'));
            await tester.pumpAndSettle();
          }

          expect(find.text('Total Items: 5'), findsOneWidget);
          expect(find.text('5'), findsOneWidget);
          expect(find.text('Apple iPhone'), findsOneWidget);
        });

    testWidgets('Remove items using delete button',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add multiple items
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Add iPad'));
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 3'), findsOneWidget);

          // Delete iPhone
          final deleteButtons = find.byIcon(Icons.delete);
          await tester.tap(deleteButtons.first);
          await tester.pumpAndSettle();

          expect(find.text('Apple iPhone'), findsNothing);
          expect(find.text('Total Items: 2'), findsOneWidget);
        });

    testWidgets('Decrease quantity to zero removes item',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add iPhone
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          expect(find.text('Apple iPhone'), findsOneWidget);

          // Decrease to zero
          await tester.tap(find.byIcon(Icons.remove));
          await tester.pumpAndSettle();

          expect(find.text('Apple iPhone'), findsNothing);
          expect(find.text('Cart is empty'), findsOneWidget);
        });

    testWidgets('Clear cart removes all items', (WidgetTester tester) async {
      await buildWidget(tester);

      // Add all items
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Galaxy'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add iPad'));
      await tester.pumpAndSettle();

      expect(find.text('Total Items: 3'), findsOneWidget);

      // Clear cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('Verify discount calculations', (WidgetTester tester) async {
      await buildWidget(tester);

      // Add iPhone (10% discount)
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      expect(find.text('Discount: 10%'), findsOneWidget);
      expect(find.text('Subtotal: \$999.99'), findsOneWidget);
      expect(find.textContaining('Total Discount: \$100.00'), findsOneWidget);

      // Add Galaxy (15% discount)
      await tester.tap(find.text('Add Galaxy'));
      await tester.pumpAndSettle();

      expect(find.text('Discount: 15%'), findsOneWidget);
      expect(find.text('Subtotal: \$1899.98'), findsOneWidget);
    });

    testWidgets('Verify no discount for iPad', (WidgetTester tester) async {
      await buildWidget(tester);

      await tester.tap(find.text('Add iPad'));
      await tester.pumpAndSettle();

      expect(find.text('iPad Pro'), findsOneWidget);
      // Check that discount percentage is NOT shown in the item details
      expect(find.text('Discount: 0%'), findsNothing);
      expect(find.text('Total Discount: \$0.00'), findsOneWidget);
    });

    testWidgets('Update quantities multiple times', (WidgetTester tester) async {
      await buildWidget(tester);

      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // Increase quantity to 5
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }

      expect(find.text('Total Items: 5'), findsOneWidget);

      // Decrease quantity to 2
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();
      }

      expect(find.text('Total Items: 2'), findsOneWidget);
    });

    testWidgets('Mixed operations - add, remove, update',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add iPhone
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          // Add Galaxy
          await tester.tap(find.text('Add Galaxy'));
          await tester.pumpAndSettle();

          // Add iPad
          await tester.tap(find.text('Add iPad'));
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 3'), findsOneWidget);

          // Increase iPhone quantity
          final addButtons = find.byIcon(Icons.add);
          await tester.tap(addButtons.first);
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 4'), findsOneWidget);

          // Remove Galaxy
          final deleteButtons = find.byIcon(Icons.delete);
          await tester.tap(deleteButtons.at(1));
          await tester.pumpAndSettle();

          expect(find.text('Samsung Galaxy'), findsNothing);
          expect(find.text('Total Items: 3'), findsOneWidget);
        });

    testWidgets('Verify item totals update correctly',
            (WidgetTester tester) async {
          await buildWidget(tester);

          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          // Initial item total
          expect(find.text('Item Total: \$999.99'), findsOneWidget);

          // Add one more
          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();

          // Updated item total
          expect(find.text('Item Total: \$1999.98'), findsOneWidget);
        });

    testWidgets('Scroll test with many items', (WidgetTester tester) async {
      await buildWidget(tester);

      // Add iPhone 10 times
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Add iPhone'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Total Items: 10'), findsOneWidget);

      // Verify scrolling works
      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      // Scroll to bottom
      await tester.drag(scrollView, const Offset(0, -500));
      await tester.pumpAndSettle();
    });

    testWidgets('Empty cart after clearing remains functional',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add items
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pumpAndSettle();

          // Clear cart
          await tester.tap(find.text('Clear Cart'));
          await tester.pumpAndSettle();

          expect(find.text('Cart is empty'), findsOneWidget);

          // Add items again to verify functionality
          await tester.tap(find.text('Add iPad'));
          await tester.pumpAndSettle();

          expect(find.text('iPad Pro'), findsOneWidget);
          expect(find.text('Total Items: 1'), findsOneWidget);
        });

    testWidgets('Stress test - rapid button tapping',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Rapidly tap add button
          for (int i = 0; i < 20; i++) {
            await tester.tap(find.text('Add iPhone'));
            await tester.pump(const Duration(milliseconds: 50));
          }
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 20'), findsOneWidget);
        });

    testWidgets('Calculate totals with multiple items and quantities',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add iPhone (999.99, 10% discount) x2
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          // Add Galaxy (899.99, 15% discount) x1
          await tester.tap(find.text('Add Galaxy'));
          await tester.pumpAndSettle();

          // Add iPad (1099.99, no discount) x1
          await tester.tap(find.text('Add iPad'));
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 4'), findsOneWidget);

          // Verify subtotal: (999.99 * 2) + 899.99 + 1099.99 = 3999.96
          expect(find.text('Subtotal: \$3999.96'), findsOneWidget);

          // Verify total discount calculation appears
          expect(find.textContaining('Total Discount:'), findsOneWidget);
          expect(find.textContaining('Total Amount:'), findsOneWidget);
        });

    testWidgets('UI elements are accessible and visible',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Verify all buttons are visible
          expect(find.text('Add iPhone'), findsOneWidget);
          expect(find.text('Add Galaxy'), findsOneWidget);
          expect(find.text('Add iPad'), findsOneWidget);
          expect(find.text('Clear Cart'), findsOneWidget);

          // Verify summary section
          expect(find.textContaining('Total Items:'), findsOneWidget);
          expect(find.textContaining('Subtotal:'), findsOneWidget);
          expect(find.textContaining('Total Discount:'), findsOneWidget);
          expect(find.textContaining('Total Amount:'), findsOneWidget);
        });

    testWidgets('Add all items then remove them one by one',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Add all items
          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Add iPad'));
          await tester.pumpAndSettle();

          expect(find.text('Total Items: 3'), findsOneWidget);

          // Remove each item
          await tester.tap(find.byIcon(Icons.delete).first);
          await tester.pumpAndSettle();
          expect(find.text('Total Items: 2'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.delete).first);
          await tester.pumpAndSettle();
          expect(find.text('Total Items: 1'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.delete).first);
          await tester.pumpAndSettle();
          expect(find.text('Cart is empty'), findsOneWidget);
        });

    testWidgets('Verify quantity display updates correctly',
            (WidgetTester tester) async {
          await buildWidget(tester);

          await tester.tap(find.text('Add iPhone'));
          await tester.pumpAndSettle();

          // Initial quantity
          expect(find.text('1'), findsOneWidget);

          // Increase to 3
          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();
          expect(find.text('2'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();
          expect(find.text('3'), findsOneWidget);

          // Decrease to 1
          await tester.tap(find.byIcon(Icons.remove));
          await tester.pumpAndSettle();
          expect(find.text('2'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.remove));
          await tester.pumpAndSettle();
          expect(find.text('1'), findsOneWidget);
        });

    testWidgets('Complex scenario - multiple operations in sequence',
            (WidgetTester tester) async {
          await buildWidget(tester);

          // Step 1: Add 3 iPhones
          for (int i = 0; i < 3; i++) {
            await tester.tap(find.text('Add iPhone'));
            await tester.pumpAndSettle();
          }
          expect(find.text('Total Items: 3'), findsOneWidget);

          // Step 2: Add 2 Galaxies
          for (int i = 0; i < 2; i++) {
            await tester.tap(find.text('Add Galaxy'));
            await tester.pumpAndSettle();
          }
          expect(find.text('Total Items: 5'), findsOneWidget);

          // Step 3: Add 1 iPad
          await tester.tap(find.text('Add iPad'));
          await tester.pumpAndSettle();
          expect(find.text('Total Items: 6'), findsOneWidget);

          // Step 4: Decrease iPhone quantity by 1
          final removeButtons = find.byIcon(Icons.remove);
          await tester.tap(removeButtons.first);
          await tester.pumpAndSettle();
          expect(find.text('Total Items: 5'), findsOneWidget);

          // Step 5: Remove Galaxy completely
          final deleteButtons = find.byIcon(Icons.delete);
          await tester.tap(deleteButtons.at(1));
          await tester.pumpAndSettle();
          expect(find.text('Total Items: 3'), findsOneWidget);

          // Step 6: Verify remaining items
          expect(find.text('Apple iPhone'), findsOneWidget);
          expect(find.text('Samsung Galaxy'), findsNothing);
          expect(find.text('iPad Pro'), findsOneWidget);
        });
  });
}