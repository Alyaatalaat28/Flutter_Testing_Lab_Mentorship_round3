import 'package:flutter_test/flutter_test.dart';

void main() {
 

  late ShoppingCartTestHelper cart;

  setUp(() {
    // Create a fresh cart before each test
    cart = ShoppingCartTestHelper();
  });

  // GROUP: Adding Items Tests
  group('Adding Items to Cart', () {
    test('should add new item to empty cart', () {
      // ACT: Add an item
      cart.addItem('1', 'iPhone', 999.99, discount: 0.1);

      // ASSERT: Cart should have 1 item
      expect(cart.items.length, 1);
      expect(cart.items[0].name, 'iPhone');
      expect(cart.items[0].price, 999.99);
      expect(cart.items[0].quantity, 1);
      expect(cart.items[0].discount, 0.1);
    });

    test('should update quantity when adding duplicate item by ID', () {
      // ARRANGE: Add iPhone once
      cart.addItem('1', 'iPhone', 999.99, discount: 0.1);

      // ACT: Add iPhone again (same ID)
      cart.addItem('1', 'iPhone', 999.99, discount: 0.1);

      // ASSERT: Should still have 1 item, but quantity = 2
      expect(cart.items.length, 1, reason: 'Should not create duplicate entry');
      expect(cart.items[0].quantity, 2, reason: 'Quantity should increment');
    });

    test('should add multiple different items', () {
      // ACT: Add 3 different items
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Galaxy', 899.99);
      cart.addItem('3', 'iPad', 1099.99);

      // ASSERT: Should have 3 items
      expect(cart.items.length, 3);
    });

    test('should handle items without discount', () {
      // ACT: Add item with no discount
      cart.addItem('1', 'iPad', 1099.99);

      // ASSERT: Discount should be 0.0
      expect(cart.items[0].discount, 0.0);
    });
  });

  // GROUP: Removing Items Tests
  group('Removing Items from Cart', () {
    test('should remove item by ID', () {
      // ARRANGE: Add 2 items
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Galaxy', 899.99);

      // ACT: Remove iPhone
      cart.removeItem('1');

      // ASSERT: Should have 1 item left (Galaxy)
      expect(cart.items.length, 1);
      expect(cart.items[0].id, '2');
    });

    test('should handle removing non-existent item', () {
      // ARRANGE: Add 1 item
      cart.addItem('1', 'iPhone', 999.99);

      // ACT: Try to remove item that doesn't exist
      cart.removeItem('999');

      // ASSERT: Should still have 1 item (no error)
      expect(cart.items.length, 1);
    });

    test('should clear entire cart', () {
      // ARRANGE: Add multiple items
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Galaxy', 899.99);
      cart.addItem('3', 'iPad', 1099.99);

      // ACT: Clear cart
      cart.clearCart();

      // ASSERT: Cart should be empty
      expect(cart.items.length, 0);
      expect(cart.items.isEmpty, true);
    });
  });

  // GROUP: Quantity Update Tests
  group('Updating Item Quantity', () {
    test('should increase quantity', () {
      // ARRANGE: Add item
      cart.addItem('1', 'iPhone', 999.99);

      // ACT: Update quantity to 5
      cart.updateQuantity('1', 5);

      // ASSERT: Quantity should be 5
      expect(cart.items[0].quantity, 5);
    });

    test('should decrease quantity', () {
      // ARRANGE: Add item with quantity 3
      cart.addItem('1', 'iPhone', 999.99);
      cart.updateQuantity('1', 3);

      // ACT: Decrease to 1
      cart.updateQuantity('1', 1);

      // ASSERT: Quantity should be 1
      expect(cart.items[0].quantity, 1);
    });

    test('should remove item when quantity set to 0', () {
      // ARRANGE: Add item
      cart.addItem('1', 'iPhone', 999.99);

      // ACT: Set quantity to 0
      cart.updateQuantity('1', 0);

      // ASSERT: Item should be removed
      expect(cart.items.length, 0);
    });

    test('should remove item when quantity is negative', () {
      // ARRANGE: Add item
      cart.addItem('1', 'iPhone', 999.99);

      // ACT: Set quantity to -1
      cart.updateQuantity('1', -1);

      // ASSERT: Item should be removed
      expect(cart.items.length, 0);
    });
  });

  // GROUP: Calculation Tests (MOST IMPORTANT!)
  group('Cart Calculations', () {
    test('should calculate subtotal correctly', () {
      // ARRANGE: Add items
      cart.addItem('1', 'iPhone', 999.99); // $999.99
      cart.addItem('2', 'Galaxy', 899.99); // $899.99
      // Expected: $1899.98

      // ASSERT: Subtotal should be sum of all items
      expect(cart.subtotal, 1899.98);
    });

    test('should calculate subtotal with quantities', () {
      // ARRANGE: Add items with quantities
      cart.addItem('1', 'iPhone', 100.0); // 1 item
      cart.addItem('1', 'iPhone', 100.0); // Now 2 items
      cart.addItem('1', 'iPhone', 100.0); // Now 3 items
      // Expected: 3 * $100 = $300

      // ASSERT
      expect(cart.subtotal, 300.0);
    });

    test('should calculate discount correctly', () {
      // ARRANGE: Add iPhone with 10% discount
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
      // Price: $1000, Discount: 10%
      // Expected discount: $1000 * 0.1 = $100

      // ASSERT
      expect(cart.totalDiscount, 100.0);
    });

    test('should calculate discount with quantity', () {
      // ARRANGE: Add 3 iPhones with 10% discount
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
      cart.updateQuantity('1', 3);
      // Price: $1000 x 3 = $3000, Discount: 10%
      // Expected discount: $3000 * 0.1 = $300

      // ASSERT
      expect(cart.totalDiscount, 300.0);
    });

    test('should calculate total amount correctly (subtotal - discount)', () {
      // ARRANGE: Add iPhone with 10% discount
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
      // Subtotal: $1000
      // Discount: $100
      // Total: $1000 - $100 = $900

      // ASSERT: Total should be subtotal MINUS discount
      expect(cart.totalAmount, 900.0);
    });

    test('should calculate total with multiple items and discounts', () {
      // ARRANGE:
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);  // $1000 - $100 = $900
      cart.addItem('2', 'Galaxy', 800.0, discount: 0.15);  // $800 - $120 = $680
      cart.addItem('3', 'iPad', 500.0);                    // $500 (no discount)
      // Subtotal: $2300
      // Total Discount: $220
      // Total: $2080

      // ASSERT
      expect(cart.subtotal, 2300.0);
      expect(cart.totalDiscount, 220.0);
      expect(cart.totalAmount, 2080.0);
    });

    test('should calculate total items count', () {
      // ARRANGE: Add items with different quantities
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('1', 'iPhone', 999.99); // Quantity = 2
      cart.addItem('2', 'Galaxy', 899.99); // Quantity = 1
      cart.addItem('3', 'iPad', 1099.99);
      cart.updateQuantity('3', 5);         // Quantity = 5
      // Total: 2 + 1 + 5 = 8 items

      // ASSERT
      expect(cart.totalItems, 8);
    });
  });

  // GROUP: Edge Cases (BONUS TESTS!)
  group('Edge Case Testing', () {
    test('should handle empty cart calculations', () {
      // Empty cart
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
      expect(cart.totalItems, 0);
    });

    test('should handle 100% discount', () {
      // ARRANGE: Item with 100% discount (free!)
      cart.addItem('1', 'Free Item', 1000.0, discount: 1.0);

      // ASSERT: Total should be $0
      expect(cart.totalDiscount, 1000.0);
      expect(cart.totalAmount, 0.0);
    });

    test('should handle very large quantities', () {
      // ARRANGE: Add 1000 items
      cart.addItem('1', 'iPhone', 100.0);
      cart.updateQuantity('1', 1000);

      // ASSERT
      expect(cart.totalItems, 1000);
      expect(cart.subtotal, 100000.0);
    });

    test('should handle decimal prices correctly', () {
      // ARRANGE: Add items with decimal prices
      cart.addItem('1', 'Item A', 19.99);
      cart.addItem('2', 'Item B', 29.95);

      // ASSERT: Should handle decimals without rounding errors
      expect(cart.subtotal, closeTo(49.94, 0.01));
    });

    test('should handle small discount percentages', () {
      // ARRANGE: 1% discount
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.01);

      // ASSERT: Discount should be $10
      expect(cart.totalDiscount, 10.0);
      expect(cart.totalAmount, 990.0);
    });
  });
}

// ============================================
// TEST HELPER CLASS
// ============================================
// Simulates the shopping cart logic without Flutter widgets

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });
}

class ShoppingCartTestHelper {
  final List<CartItem> items = [];

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    final existingIndex = items.indexWhere((item) => item.id == id);

    if (existingIndex != -1) {
      items[existingIndex].quantity += 1;
    } else {
      items.add(
        CartItem(id: id, name: name, price: price, discount: discount),
      );
    }
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = newQuantity;
      }
    }
  }

  void clearCart() {
    items.clear();
  }

  double get subtotal {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalDiscount {
    double discount = 0;
    for (var item in items) {
      discount += item.price * item.quantity * item.discount;
    }
    return discount;
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
