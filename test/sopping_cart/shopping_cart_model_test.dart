import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/models/shopping_cart_model.dart';

void main() {
  group('ShoppingCartModel', () {
    test('addItem adds new item when not existing', () {
      final cart = ShoppingCartModel();
      cart.addItem('1', 'Item 1', 10.0);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 1);
      expect(cart.subtotal, 10.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 10.0);
    });

    test('addItem increases quantity when duplicate added', () {
      final cart = ShoppingCartModel();
      cart.addItem('1', 'Item 1', 10.0);
      cart.addItem('1', 'Item 1', 10.0);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.totalItems, 2);
      expect(cart.subtotal, 20.0);
    });

    test('discount calculation is correct', () {
      final cart = ShoppingCartModel();
      cart.addItem('1', 'Item 1', 100.0, discount: 0.1);
      cart.addItem('2', 'Item 2', 50.0, discount: 0.2);

      expect(cart.subtotal, 150.0);
      // totalDiscount = 100*0.1 + 50*0.2 = 20
      expect(cart.totalDiscount, 20.0);
      // totalAmount = 150 - 20 = 130
      expect(cart.totalAmount, 130.0);
    });

    test('removeItem removes the item', () {
      final cart = ShoppingCartModel();
      cart.addItem('1', 'Item 1', 10.0);
      cart.addItem('2', 'Item 2', 20.0);
      expect(cart.items.length, 2);
      cart.removeItem('1');
      expect(cart.items.length, 1);
      expect(cart.items.first.id, '2');
    });

    test('updateQuantity removes item if set to zero', () {
      final cart = ShoppingCartModel();
      cart.addItem('1', 'Item 1', 10.0, quantity: 2);
      cart.updateQuantity('1', 0);
      expect(cart.items.length, 0);
    });

    test('empty cart edge case', () {
      final cart = ShoppingCartModel();
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
      expect(cart.totalItems, 0);
    });

    test('100% discount edge case', () {
      final cart = ShoppingCartModel();
      cart.addItem('1', 'Free Item', 50.0, discount: 1.0);
      expect(cart.subtotal, 50.0);
      expect(cart.totalDiscount, 50.0);
      expect(cart.totalAmount, 0.0);
    });

    test('quantity limits enforced (maxQuantity)', () {
      final cart = ShoppingCartModel(maxQuantity: 5);
      cart.addItem('1', 'A', 10.0, quantity: 3);
      cart.addItem('1', 'A', 10.0, quantity: 4);
      expect(cart.items.first.quantity, 5);
    });
  });
}
