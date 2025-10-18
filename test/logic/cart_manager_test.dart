import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/logic/cart_manager.dart';

void main() {
  group('CartManager', () {
    late CartManager cart;

    setUp(() {
      cart = CartManager();
    });

    test('Add single item', () {
      cart.addItem('a', 'Apple', 1.0);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 1);
      expect(cart.subtotal, 1.0);
    });

    test('Add duplicate item updates quantity', () {
      cart.addItem('a', 'Apple', 1.0);
      cart.addItem('a', 'Apple', 1.0);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.subtotal, 2.0);
    });

    test('Remove item', () {
      cart.addItem('a', 'Apple', 1.0);
      cart.removeItem('a');
      expect(cart.items, isEmpty);
      expect(cart.subtotal, 0);
    });

    test('Update quantity increases and removes when zero', () {
      cart.addItem('a', 'Apple', 2.0);
      cart.updateQuantity('a', 5);
      expect(cart.items.first.quantity, 5);
      cart.updateQuantity('a', 0);
      expect(cart.items, isEmpty);
    });

    test('Subtotal, discount, and total calculations are correct', () {
      cart.addItem('a', 'Apple', 10, discount: 0.1); 
      cart.addItem('b', 'Banana', 20, discount: 0.25);
      expect(cart.subtotal, 10 + 20);
      expect(cart.totalDiscount, closeTo(1 + 5, 0.0001));
      expect(cart.totalAmount, closeTo(30 - 6, 0.0001));
    });

    test('Cart handles empty state and totals return zero', () {
      expect(cart.subtotal, 0);
      expect(cart.totalDiscount, 0);
      expect(cart.totalAmount, 0);
    });

    test('Discount clamps at 0% and 100%', () {
      cart.addItem('a', 'Zero', 50, discount: -0.5);
      cart.addItem('b', 'Full', 100, discount: 1.5);
      expect(cart.totalDiscount, closeTo(0 * 50 * 1 + 1 * 100 * 1, 0.0001));
      expect(cart.totalAmount, closeTo(50 + 100 - 100, 0.0001));
    });
  });
}
