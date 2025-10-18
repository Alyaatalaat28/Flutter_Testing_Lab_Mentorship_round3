import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart_logic.dart';

void main() {
  group('CartItem', () {
    test('creates cart item with default values', () {
      final item = CartItem(id: '1', name: 'Test Product', price: 100.0);
      expect(item.id, '1');
      expect(item.name, 'Test Product');
      expect(item.price, 100.0);
      expect(item.quantity, 1);
      expect(item.discount, 0.0);
    });
  });

  group("Cart manager Basic operations", () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
    });

    test('Initial state should be empty', () {
      expect(cartManager.items, isEmpty);
      expect(cartManager.isEmpty, isTrue);
      expect(cartManager.isNotEmpty, isFalse);
      expect(cartManager.totalItems, equals(0));
      expect(cartManager.subtotal, equals(0));
      expect(cartManager.totalDiscount, equals(0));
      expect(cartManager.totalAmount, equals(0));
    });
    test('Add new item to empty cart', () {
      final item = CartItem(
        id: '1',
        name: 'Test Item',
        price: 10.0,
        quantity: 1,
        discount: 0.1,
      );

      cartManager.addItem(item);

      expect(cartManager.items.length, equals(1));
      expect(cartManager.items[0].id, equals('1'));
      expect(cartManager.items[0].quantity, equals(1));
      expect(cartManager.totalItems, equals(1));
    });
    test('Add duplicate item should increase quantity', () {
      final item = CartItem(
        id: '1',
        name: 'Test Item',
        price: 10.0,
        quantity: 1,
        discount: 0.1,
      );

      cartManager.addItem(item);
      cartManager.addItem(item); // Add same item again

      expect(cartManager.items.length, equals(1));
      expect(cartManager.items[0].quantity, equals(2));
      expect(cartManager.totalItems, equals(2));
    });

    test('Remove existing item', () {
      final item = CartItem(id: '1', name: 'Test Item', price: 10.0);

      cartManager.addItem(item);
      expect(cartManager.items.length, equals(1));

      cartManager.removeItem('1');
      expect(cartManager.items, isEmpty);
    });
    test('Update quantity to positive number', () {
      final item = CartItem(id: '1', name: 'Test Item', price: 10.0);

      cartManager.addItem(item);
      cartManager.updateQuantity('1', 5);

      expect(cartManager.items[0].quantity, equals(5));
      expect(cartManager.totalItems, equals(5));
    });
    test('Update quantity to zero should remove item', () {
      final item = CartItem(id: '1', name: 'Test Item', price: 10.0);

      cartManager.addItem(item);
      cartManager.updateQuantity('1', 0);

      expect(cartManager.items, isEmpty);
    });

    test('Clear cart with items', () {
      final item1 = CartItem(id: '1', name: 'Item 1', price: 10.0);
      final item2 = CartItem(id: '2', name: 'Item 2', price: 20.0);

      cartManager.addItem(item1);
      cartManager.addItem(item2);

      expect(cartManager.items.length, equals(2));

      cartManager.clearCart();
      expect(cartManager.items, isEmpty);
      expect(cartManager.totalItems, equals(0));
    });
  });

  group('CartManager Calculation Tests', () {
    late CartManager cartManager;

    setUp(() {
      cartManager = CartManager();
    });

    test('Subtotal calculation with multiple items', () {
      final testItems = [
        CartItem(id: '1', name: 'Item 1', price: 10.0, quantity: 2),
        CartItem(id: '2', name: 'Item 2', price: 15.0, quantity: 3),
      ];

      cartManager.setItemsForTesting(testItems);

      // (10 * 2) + (15 * 3) = 20 + 45 = 65
      expect(cartManager.subtotal, equals(65.0));
    });
    test('Total discount calculation', () {
      final cartManager = CartManager();
      final testItems = [
        CartItem(
          id: '1',
          name: 'Item 1',
          price: 100.0,
          quantity: 2,
          discount: 0.1,
        ),
        CartItem(
          id: '2',
          name: 'Item 2',
          price: 50.0,
          quantity: 1,
          discount: 0.2,
        ),
      ];

      cartManager.setItemsForTesting(testItems);
      expect(cartManager.totalDiscount, equals(30.0));
    });

    test('Calculates total amount correctly after discounts', () {
      final items = [
        CartItem(id: '1', name: 'iPhone', price: 1000.0, discount: 0.1),
        CartItem(id: '2', name: 'Galaxy', price: 500.0, discount: 0.2),
      ];
      cartManager.setItemsForTesting(items);

      final subtotal = 1500.0;
      final discount = (1000 * 0.1) + (500 * 0.2);
      final expectedTotal = subtotal - discount;

      expect(cartManager.subtotal, subtotal);
      expect(cartManager.totalAmount, expectedTotal);
    });
    test('Item with 100% discount results in zero total amount', () {
      final items = [
        CartItem(id: '1', name: 'Promo', price: 100.0, discount: 1.0),
      ];
      cartManager.setItemsForTesting(items);

      expect(cartManager.totalDiscount, 100.0);
      expect(cartManager.totalAmount, 0.0);
    });
  });
}
