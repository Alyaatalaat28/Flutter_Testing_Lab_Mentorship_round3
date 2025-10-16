// test/unit/cart_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/services/cart_service.dart';

void main() {
  group('CartService', () {
    late CartService cart;

    setUp(() {
      cart = CartService();
    });

    test('adds item and increases quantity when same id added again', () {
      cart.addItem(id: '1', name: 'Phone', price: 100.0, quantityToAdd: 1);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 1);

      cart.addItem(id: '1', name: 'Phone', price: 100.0, quantityToAdd: 2);
      expect(cart.items.length, 1, reason: 'should not create duplicate entries');
      expect(cart.items.first.quantity, 3);
    });

    test('removes item correctly', () {
      cart.addItem(id: '1', name: 'Phone', price: 100.0);
      cart.addItem(id: '2', name: 'Tablet', price: 200.0);
      expect(cart.items.length, 2);
      cart.removeItem('1');
      expect(cart.items.length, 1);
      expect(cart.items.first.id, '2');
    });

    test('updateQuantity removes when set to zero', () {
      cart.addItem(id: '1', name: 'Phone', price: 100.0, quantityToAdd: 2);
      expect(cart.items.first.quantity, 2);
      cart.updateQuantity('1', 0);
      expect(cart.items.isEmpty, isTrue);
    });

    test('subtotal, totalDiscount and totalAmount calculation', () {
      // item1: price 100, qty 2, discount 10% -> subtotal contribution 200, discount 20
      cart.addItem(id: '1', name: 'A', price: 100.0, quantityToAdd: 2, discount: 0.1);

      // item2: price 50, qty 1, discount 0% -> subtotal 50, discount 0
      cart.addItem(id: '2', name: 'B', price: 50.0, quantityToAdd: 1, discount: 0.0);

      expect(cart.subtotal, closeTo(250.0, 0.001));
      expect(cart.totalDiscount, closeTo(20.0, 0.001));
      expect(cart.totalAmount, closeTo(230.0, 0.001)); // 250 - 20
    });

    test('empty cart returns zeros', () {
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
    });

    test('100% discount makes item free', () {
      cart.addItem(id: '1', name: 'Freebie', price: 100.0, quantityToAdd: 3, discount: 1.0);
      expect(cart.subtotal, closeTo(300.0, 0.001));
      expect(cart.totalDiscount, closeTo(300.0, 0.001));
      expect(cart.totalAmount, closeTo(0.0, 0.001));
    });

    test('totalItems sums quantities', () {
      cart.addItem(id: '1', name: 'A', price: 10.0, quantityToAdd: 2);
      cart.addItem(id: '2', name: 'B', price: 5.0, quantityToAdd: 3);
      expect(cart.totalItems, 5);
    });
  });
}
