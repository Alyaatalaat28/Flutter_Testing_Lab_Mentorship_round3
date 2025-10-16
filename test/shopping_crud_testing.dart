import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group("Shopping Cart Tests", () {
    // Helper function
    Future<ShoppingCartState> setupCart(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );
      return tester.state<ShoppingCartState>(find.byType(ShoppingCart));
    }

    testWidgets("should add items and calculate totals", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);

      // ACT
      state.addItem("1", "Apple", 1.0, discount: 0.1);
      state.addItem("2", "Banana", 0.5);
      state.addItem("1", "Apple", 1.0, discount: 0.1);
      await tester.pump();

      // ASSERT
      expect(state.items.length, 2);
      expect(state.items.firstWhere((item) => item.id == "1").quantity, 2);
      expect(state.items.firstWhere((item) => item.id == "2").quantity, 1);
      expect(state.subtotal, 2.5);
      expect(state.totalDiscount, 0.2);
      expect(state.totalAmount, 2.3);
      expect(state.totalItems, 3);
    });

    testWidgets("should remove item from cart", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);
      state.addItem("1", "Apple", 1.0);
      state.addItem("2", "Banana", 0.5);

      // ACT
      state.removeItem("1");
      await tester.pump();

      // ASSERT
      expect(state.items.length, 1);
      expect(state.items.any((item) => item.id == "1"), false);
      expect(state.totalAmount, 0.5);
    });

    testWidgets("should update quantity", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);
      state.addItem("1", "Apple", 1.0);

      // ACT
      state.updateQuantity("1", 5);
      await tester.pump();

      // ASSERT
      expect(state.items.first.quantity, 5);
      expect(state.totalAmount, 5.0);
    });
       
    testWidgets("should remove when quantity is 0", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);
      state.addItem("1", "Apple", 1.0);

      // ACT
      state.updateQuantity("1", 0);
      await tester.pump();

      // ASSERT
      expect(state.items.length, 0);
    });

    testWidgets("should clear cart", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);
      state.addItem("1", "Apple", 1.0);
      state.addItem("2", "Banana", 0.5);

      // ACT
      state.clearCart();
      await tester.pump();

      // ASSERT
      expect(state.items.length, 0);
      expect(state.totalAmount, 0.0);
    });

    testWidgets("should calculate discount", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);

      // ACT
      state.addItem("1", "Laptop", 1000.0, discount: 0.2);
      await tester.pump();

      // ASSERT
      expect(state.subtotal, 1000.0);
      expect(state.totalDiscount, 200.0);
      expect(state.totalAmount, 800.0);
    });

    testWidgets("should handle 100% discount", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);

      // ACT
      state.addItem("1", "Free", 50.0, discount: 1.0);
      await tester.pump();

      // ASSERT
      expect(state.totalAmount, 0.0);
      expect(state.totalDiscount, 50.0);
    });

    testWidgets("should handle large quantity", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);

      // ACT
      state.addItem("1", "Product", 10.0);
      state.updateQuantity("1", 999);
      await tester.pump();

      // ASSERT
      expect(state.items.first.quantity, 999);
      expect(state.subtotal, 9990.0);
    });

    testWidgets("should handle negative quantity", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);
      state.addItem("1", "Apple", 1.0);

      // ACT
      state.updateQuantity("1", -5);
      await tester.pump();

      // ASSERT
      expect(state.items.length, 0);
    });

    testWidgets("should handle empty cart", (tester) async {
      // ARRANGE
      final state = await setupCart(tester);

      // ASSERT
      expect(state.items.length, 0);
      expect(state.totalAmount, 0.0);
      expect(state.totalItems, 0);
    });
  });
}
