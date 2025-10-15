import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  // ============================================
  // WIDGET TESTS - Testing Shopping Cart UI
  // ============================================

  group('Shopping Cart Widget Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: Scaffold(
          body: ShoppingCart(),
        ),
      );
    }

    testWidgets('should display all product buttons', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ASSERT: All product buttons should be visible
      expect(find.text('Add iPhone'), findsOneWidget);
      expect(find.text('Add Galaxy'), findsOneWidget);
      expect(find.text('Add iPad'), findsOneWidget);
      expect(find.text('Add iPhone Again'), findsOneWidget);
    });

    testWidgets('should show empty cart message initially', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ASSERT: Empty cart message should be visible
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('should display initial totals as zero', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ASSERT: All totals should be 0
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text('Subtotal: \$0.00'), findsOneWidget);
      expect(find.text('Total Discount: \$0.00'), findsOneWidget);
      expect(find.text('Total Amount: \$0.00'), findsOneWidget);
    });

    testWidgets('should add item to cart when button tapped', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Tap "Add iPhone" button
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ASSERT: Cart should no longer be empty
      expect(find.text('Cart is empty'), findsNothing);
      expect(find.text('Apple iPhone'), findsOneWidget);
    });

    testWidgets('should update quantity when adding duplicate item', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone twice
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add iPhone Again'));
      await tester.pump();

      // ASSERT: Should show quantity 2, not 2 separate items
      expect(find.text('Apple iPhone'), findsOneWidget, reason: 'Should be only one item card');
      expect(find.text('2'), findsOneWidget, reason: 'Quantity should be 2');
    });

    testWidgets('should display correct subtotal after adding items', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone ($999.99)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ASSERT: Subtotal should be $999.99
      expect(find.text('Subtotal: \$999.99'), findsOneWidget);
    });

    testWidgets('should calculate discount correctly', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone with 10% discount ($999.99 * 0.1 = $99.999 ≈ $100.00)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ASSERT: Discount should be approximately $100
      expect(find.text('Total Discount: \$100.00'), findsOneWidget);
    });

    testWidgets('should calculate total amount correctly (subtotal - discount)', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone
      // Subtotal: $999.99, Discount: $100.00, Total: $899.99
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ASSERT: Total should be subtotal - discount
      expect(find.text('Total Amount: \$899.99'), findsOneWidget);
    });

    testWidgets('should increase quantity when + button tapped', (WidgetTester tester) async {
      // ARRANGE: Add item to cart
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ACT: Tap the + button
      final addButton = find.widgetWithIcon(IconButton, Icons.add);
      await tester.tap(addButton.first);
      await tester.pump();

      // ASSERT: Quantity should be 2
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Total Items: 2'), findsOneWidget);
    });

    testWidgets('should decrease quantity when - button tapped', (WidgetTester tester) async {
      // ARRANGE: Add item with quantity 2
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add iPhone Again'));
      await tester.pump();

      // ACT: Tap the - button
      final removeButton = find.widgetWithIcon(IconButton, Icons.remove);
      await tester.tap(removeButton.first);
      await tester.pump();

      // ASSERT: Quantity should be 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should remove item when quantity becomes 0', (WidgetTester tester) async {
      // ARRANGE: Add item
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ACT: Tap - button to decrease to 0
      final removeButton = find.widgetWithIcon(IconButton, Icons.remove);
      await tester.tap(removeButton.first);
      await tester.pump();

      // ASSERT: Item should be removed, cart should be empty
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsNothing);
    });

    testWidgets('should remove item when delete button tapped', (WidgetTester tester) async {
      // ARRANGE: Add item
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ACT: Tap delete button
      final deleteButton = find.widgetWithIcon(IconButton, Icons.delete);
      await tester.tap(deleteButton);
      await tester.pump();

      // ASSERT: Cart should be empty
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsNothing);
    });

    testWidgets('should clear entire cart when Clear Cart button tapped', (WidgetTester tester) async {
      // ARRANGE: Add multiple items
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // ACT: Tap "Clear Cart" button
      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      // ASSERT: Cart should be empty
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('should display discount percentage on items', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone (10% discount)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ASSERT: Should show "Discount: 10%"
      expect(find.text('Discount: 10%'), findsOneWidget);
    });

    testWidgets('should not show discount label for items without discount', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPad (no discount)
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // ASSERT: Should NOT show discount label
      expect(find.textContaining('Discount:'), findsNothing);
    });

    testWidgets('should calculate total items correctly with multiple products', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone (x2), Galaxy (x1), iPad (x1)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add iPhone Again'));
      await tester.pump();
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // ASSERT: Total items = 2 + 1 + 1 = 4
      expect(find.text('Total Items: 4'), findsOneWidget);
    });

    testWidgets('should display item price correctly', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // ASSERT: Should show price
      expect(find.text('Price: \$999.99 each'), findsOneWidget);
    });

    testWidgets('should calculate item total correctly', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Add iPhone and increase quantity to 2
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      final addButton = find.widgetWithIcon(IconButton, Icons.add);
      await tester.tap(addButton.first);
      await tester.pump();

      // ASSERT: Item total should be $999.99 * 2 = $1999.98
      expect(find.text('Item Total: \$1999.98'), findsOneWidget);
    });

    testWidgets('should handle complex scenario with multiple operations', (WidgetTester tester) async {
      // ARRANGE: Build widget
      await tester.pumpWidget(createTestWidget());

      // ACT: Complex scenario
      // 1. Add iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // 2. Add Galaxy
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      // 3. Increase iPhone quantity
      final addButtons = find.widgetWithIcon(IconButton, Icons.add);
      await tester.tap(addButtons.first);
      await tester.pump();

      // 4. Add iPad
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // 5. Remove Galaxy
      final deleteButtons = find.widgetWithIcon(IconButton, Icons.delete);
      await tester.tap(deleteButtons.at(1)); // Second delete button (Galaxy)
      await tester.pump();

      // ASSERT: Should have iPhone (qty 2) and iPad (qty 1)
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Samsung Galaxy'), findsNothing);
      expect(find.text('iPad Pro'), findsOneWidget);
      expect(find.text('Total Items: 3'), findsOneWidget);
    });
  });
}
