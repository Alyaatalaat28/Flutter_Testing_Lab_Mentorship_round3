import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/feature/shop_feature/model/CartManager.dart';

void main() {
  group('CartItem', () {
    test('should create CartItem with required fields', () {
      final item = CartItem(
        id: '1',
        name: 'iPhone',
        price: 999.99,
      );

      expect(item.id, '1');
      expect(item.name, 'iPhone');
      expect(item.price, 999.99);
      expect(item.quantity, 1);
      expect(item.discount, 0.0);
    });

    test('should create CartItem with discount', () {
      final item = CartItem(
        id: '1',
        name: 'iPhone',
        price: 999.99,
        discount: 0.1,
        quantity: 2,
      );

      expect(item.discount, 0.1);
      expect(item.quantity, 2);
    });
  });

  group('CartManager - Add Item', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
    });

    test('should add new item to empty cart', () {
      cartManager.addItem('1', 'iPhone', 999.99);

      expect(cartManager.items.length, 1);
      expect(cartManager.items[0].id, '1');
      expect(cartManager.items[0].name, 'iPhone');
      expect(cartManager.items[0].price, 999.99);
      expect(cartManager.items[0].quantity, 1);
    });

    test('should add item with discount', () {
      cartManager.addItem('1', 'iPhone', 999.99, discount: 0.1);

      expect(cartManager.items[0].discount, 0.1);
    });

    test('should increment quantity when adding existing item', () {
      cartManager.addItem('1', 'iPhone', 999.99);
      cartManager.addItem('1', 'iPhone', 999.99);

      expect(cartManager.items.length, 1);
      expect(cartManager.items[0].quantity, 2);
    });

    test('should add multiple different items', () {
      cartManager.addItem('1', 'iPhone', 999.99);
      cartManager.addItem('2', 'Galaxy', 899.99);
      cartManager.addItem('3', 'iPad', 1099.99);

      expect(cartManager.items.length, 3);
    });
  });

  group('CartManager - Remove Item', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
      cartManager.addItem('1', 'iPhone', 999.99);
      cartManager.addItem('2', 'Galaxy', 899.99);
    });

    test('should remove item from cart', () {
      cartManager.removeItem('1');

      expect(cartManager.items.length, 1);
      expect(cartManager.items[0].id, '2');
    });

    test('should do nothing when removing non-existent item', () {
      cartManager.removeItem('999');

      expect(cartManager.items.length, 2);
    });

    test('should remove all items when called multiple times', () {
      cartManager.removeItem('1');
      cartManager.removeItem('2');

      expect(cartManager.items.length, 0);
    });
  });

  group('CartManager - Update Quantity', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
      cartManager.addItem('1', 'iPhone', 999.99);
    });

    test('should update item quantity', () {
      cartManager.updateQuantity('1', 5);

      expect(cartManager.items[0].quantity, 5);
    });

    test('should remove item when quantity is zero', () {
      cartManager.updateQuantity('1', 0);

      expect(cartManager.items.length, 0);
    });

    test('should remove item when quantity is negative', () {
      cartManager.updateQuantity('1', -1);

      expect(cartManager.items.length, 0);
    });

    test('should do nothing when updating non-existent item', () {
      cartManager.updateQuantity('999', 5);

      expect(cartManager.items.length, 1);
      expect(cartManager.items[0].quantity, 1);
    });
  });

  group('CartManager - Clear Cart', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
      cartManager.addItem('1', 'iPhone', 999.99);
      cartManager.addItem('2', 'Galaxy', 899.99);
    });

    test('should clear all items from cart', () {
      cartManager.clearCart();

      expect(cartManager.items.length, 0);
    });

    test('should work on empty cart', () {
      cartManager.clearCart();
      cartManager.clearCart();

      expect(cartManager.items.length, 0);
    });
  });

  group('CartManager - Calculations', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
    });

    test('should calculate subtotal correctly', () {
      cartManager.addItem('1', 'iPhone', 100.0);
      cartManager.addItem('2', 'Galaxy', 200.0);

      expect(cartManager.subtotal, 300.0);
    });

    test('should calculate subtotal with multiple quantities', () {
      cartManager.addItem('1', 'iPhone', 100.0);
      cartManager.addItem('1', 'iPhone', 100.0);
      cartManager.addItem('1', 'iPhone', 100.0);

      expect(cartManager.subtotal, 300.0);
    });

    test('should calculate total discount correctly', () {
      cartManager.addItem('1', 'iPhone', 100.0, discount: 0.1);
      cartManager.addItem('2', 'Galaxy', 200.0, discount: 0.2);

      expect(cartManager.totalDiscount, 50.0); // 10 + 40
    });

    test('should calculate total amount correctly', () {
      cartManager.addItem('1', 'iPhone', 100.0, discount: 0.1);
      cartManager.addItem('2', 'Galaxy', 200.0, discount: 0.2);

      expect(cartManager.subtotal, 300.0);
      expect(cartManager.totalDiscount, 50.0);
      expect(cartManager.totalAmount, 250.0);
    });

    test('should calculate total items correctly', () {
      cartManager.addItem('1', 'iPhone', 999.99);
      cartManager.addItem('1', 'iPhone', 999.99);
      cartManager.addItem('2', 'Galaxy', 899.99);

      expect(cartManager.totalItems, 3);
    });

    test('should return zero for empty cart calculations', () {
      expect(cartManager.subtotal, 0.0);
      expect(cartManager.totalDiscount, 0.0);
      expect(cartManager.totalAmount, 0.0);
      expect(cartManager.totalItems, 0);
    });

    test('should calculate correctly with no discount', () {
      cartManager.addItem('1', 'iPhone', 999.99);

      expect(cartManager.totalDiscount, 0.0);
      expect(cartManager.totalAmount, 999.99);
    });
  });

  group('CartManager - Items List', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
    });

    test('should return unmodifiable list', () {
      cartManager.addItem('1', 'iPhone', 999.99);
      final items = cartManager.items;

      expect(() => items.add(CartItem(id: '2', name: 'Galaxy', price: 899.99)),
          throwsUnsupportedError);
    });

    test('should return empty list for empty cart', () {
      expect(cartManager.items.length, 0);
      expect(cartManager.items, isEmpty);
    });
  });
}