import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

// 💡 IMPORTANT: Replace with your actual file path

void main() {
  // Use a GlobalKey of the public State type.
  final GlobalKey<State<ShoppingCart>> cartKey = GlobalKey();

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(body: ShoppingCart(key: cartKey)),
    );
  }

  // Helper function to safely retrieve the State object.
  // We must return 'dynamic' to call private methods like 'addItem'.
  // However, we now use the public 'items' getter for field access.
  dynamic getCartState(WidgetTester tester) {
    // Retrieve the state object using the public type State<ShoppingCart>
    final state = tester.state<State<ShoppingCart>>(find.byKey(cartKey));

    // Return it as dynamic to bypass Dart's visibility checks for private methods (addItem, etc.)
    return state as dynamic;
  }

  group('ShoppingCart Logic Unit Tests', () {
    testWidgets('addItem should increment quantity for existing ID (Fix 1)', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      final cartState = getCartState(tester);

      // 1. Add item 'A' (Qty 1)
      cartState.addItem('A', 'Item A', 10.0);

      // ⭐️ FIX: Use public getter 'items' ⭐️
      expect(cartState.items.length, 1);

      // 2. Add item 'A' again (Qty 2)
      cartState.addItem('A', 'Item A', 10.0);
      await tester.pump();

      expect(cartState.items.length, 1);
      expect(cartState.items.first.quantity, 2);
    });

    testWidgets(
      'updateQuantity removes item if new quantity is <= 0 (Edge Case)',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        final cartState = getCartState(tester);

        cartState.addItem('X', 'Item X', 10.0);
        expect(
          cartState.items.length,
          1,
        ); // ⭐️ FIX: Use public getter 'items' ⭐️

        // 1. Set quantity to 0 -> should remove
        cartState.updateQuantity('X', 0);
        await tester.pump();
        expect(
          cartState.items.length,
          0,
        ); // ⭐️ FIX: Use public getter 'items' ⭐️
      },
    );

    testWidgets('clearCart removes all items', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      final cartState = getCartState(tester);

      cartState.addItem('A', 'Item A', 1.0);
      cartState.addItem('B', 'Item B', 2.0);
      expect(cartState.items.length, 2); // ⭐️ FIX: Use public getter 'items' ⭐️

      cartState.clearCart();
      await tester.pump();

      expect(cartState.items.length, 0); // ⭐️ FIX: Use public getter 'items' ⭐️
    });

    group('Price and Total Calculations (Fix 2 & 3)', () {
      testWidgets('totalDiscount calculates correct monetary discount', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        final cartState = getCartState(tester);

        // Item 1: Price 10.00, Discount 10% (0.1) -> $1.00 discount * 2 qty = $2.00
        cartState.addItem('1', 'A', 10.0, discount: 0.1);
        cartState.addItem('1', 'A', 10.0, discount: 0.1);
        // Item 2: Price 20.00, Discount 50% (0.5) -> $10.00 discount * 1 qty = $10.00
        cartState.addItem('2', 'B', 20.0, discount: 0.5);
        await tester.pump();

        // Total Discount: 2.00 + 10.00 = 12.00
        expect(cartState.totalDiscount, closeTo(12.0, 0.001));
      });

      testWidgets('totalAmount calculates Subtotal - Discount correctly', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        final cartState = getCartState(tester);

        // Item 1: 10.00 @ 10% (Qty 2) -> Subtotal $20.00, Discount $2.00
        cartState.addItem('1', 'A', 10.0, discount: 0.1);
        cartState.addItem('1', 'A', 10.0, discount: 0.1);
        // Item 2: 20.00 @ 50% (Qty 1) -> Subtotal $20.00, Discount $10.00
        cartState.addItem('2', 'B', 20.0, discount: 0.5);
        await tester.pump();

        // Total Subtotal: 40.00. Total Discount: 12.00.
        // Total Amount: 40.00 - 12.00 = 28.00
        expect(cartState.totalAmount, closeTo(28.0, 0.001));
      });

      testWidgets('totalAmount is zero for 100% discounted item (Edge Case)', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        final cartState = getCartState(tester);

        // Item: Price 100.00, Discount 100% (1.0)
        cartState.addItem('1', 'Free Item', 100.0, discount: 1.0);
        await tester.pump();

        expect(cartState.totalAmount, closeTo(0.0, 0.001));
      });
    });
  });
}
