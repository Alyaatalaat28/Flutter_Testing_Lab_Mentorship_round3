import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/cart_manager.dart';

void main() {
  late CartManager cart;

  setUp(() {
    cart = CartManager();
  });

  test('should add a new item to the cart', () {
    cart.addItem('1', 'iPhone', 1000);
    expect(cart.items.length, 1);
    expect(cart.items.first.name, 'iPhone');
  });

  test('should increase quantity if same item added again', () {
    cart.addItem('1', 'iPhone', 1000);
    cart.addItem('1', 'iPhone', 1000);
    expect(cart.items.first.quantity, 2);
  });

  test('should remove item from cart', () {
    cart.addItem('1', 'iPhone', 1000);
    cart.removeItem('1');
    expect(cart.items.isEmpty, true);
  });

  test('should update item quantity', () {
    cart.addItem('1', 'iPhone', 1000);
    cart.updateQuantity('1', 3);
    expect(cart.items.first.quantity, 3);
  });

  test('should clear all items', () {
    cart.addItem('1', 'iPhone', 1000);
    cart.addItem('2', 'Samsung', 900);
    cart.clearCart();
    expect(cart.items.isEmpty, true);
  });

  test('should calculate subtotal correctly', () {
    cart.addItem('1', 'iPhone', 1000);
    cart.addItem('2', 'Samsung', 500);
    expect(cart.subtotal, 1500);
  });

  test('should calculate total discount and total amount', () {
    cart.addItem('1', 'iPhone', 1000, discount: 0.1); // 10%
    cart.addItem('2', 'Samsung', 500, discount: 0.2); // 20%

    expect(cart.totalDiscount, 1000*0.1 + 500*0.2); // = 100 + 100 = 200
    expect(cart.totalAmount, 1500 - 200); // = 1300
  });
}
