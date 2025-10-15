import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/helpers/cart_controller.dart';

void main() {
  group('test cart functionality', () {
    test('add new item increase quntity if duplicate', () {
      final cart = CartController();

      cart.addItem('1', 'mobile', 400);
      cart.addItem('1', 'mobile', 400);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
    });
    test('calculates subtotal, discount, and total correctly', () {
      final cart = CartController();

      cart.addItem('1', 'mobile', 400, discount: .1);
      cart.addItem('2', 'tablet', 800, discount: .5, quantity: 5);
      expect(cart.subtotal, (400 + 800 * 5));
      expect(cart.totalDiscount, (400 * .1 + 800 * .5 * 5));
      expect(cart.totalAmount, (400 + 800 * 5) - (400 * .1 + 800 * .5 * 5));
    });
    test('update quantity and remove item ', () {
      final cart = CartController();

      cart.addItem('1', 'mobile', 400, discount: .1);
      cart.updateQuantity('1', 5);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 5);

      cart.updateQuantity('1', 0);
      expect(cart.items.length, 0);
    });
  });
}
