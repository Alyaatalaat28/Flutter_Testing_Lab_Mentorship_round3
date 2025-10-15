import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/models/cart_model.dart';

void main() {
  group('CartModel', () {
    test('adding duplicate item increases quantity', () {
      final cart = CartModel();
      cart.addItem('1', 'Item A', 10.0);
      cart.addItem('1', 'Item A', 10.0);

      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
    });

    test('subtotal, discount and total calculations', () {
      final cart = CartModel();
      cart.addItem('1', 'A', 100.0, discount: 0.1, quantity: 2); // 200
      cart.addItem('2', 'B', 50.0, discount: 0.2, quantity: 1); // 50

      expect(cart.subtotal, 250.0);
      // discounts: A -> 200 * 0.1 = 20, B -> 50 * 0.2 = 10 => total 30
      expect(cart.totalDiscount, closeTo(30.0, 0.001));
      expect(cart.totalAmount, closeTo(220.0, 0.001));
    });

    test('empty cart edge case', () {
      final cart = CartModel();
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
    });

    test('100% discount yields zero total for that item', () {
      final cart = CartModel();
      cart.addItem('1', 'Freebie', 20.0, discount: 1.0, quantity: 3);
      expect(cart.subtotal, 60.0);
      expect(cart.totalDiscount, closeTo(60.0, 0.001));
      expect(cart.totalAmount, 0.0);
    });

    test('quantity limits enforced', () {
      final cart = CartModel(maxQuantity: 5);
      cart.addItem('1', 'Bulk', 1.0, quantity: 10);
      expect(cart.items.first.quantity, 5);

      cart.updateQuantity('1', 0);
      expect(cart.items.length, 0);
    });
  });
}
