import 'package:flutter_testing_lab/cart_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartManager cart;

  setUp(() {
    cart = CartManager();
  });

  test('Add new item', () {
    cart.addItem('1', 'Apple', 100.0);
    expect(cart.totalItems, 1);
    expect(cart.subtotal, 100.0);
  });

  test('Add duplicate item updates quantity', () {
    cart.addItem('1', 'Apple', 100.0);
    cart.addItem('1', 'Apple', 100.0);
    expect(cart.totalItems, 2);
    expect(cart.subtotal, 200.0);
  });

  test('Update quantity', () {
    cart.addItem('1', 'Apple', 100.0);
    cart.updateQuantity('1', 3);
    expect(cart.totalItems, 3);
    expect(cart.subtotal, 300.0);
  });

  test('Remove item', () {
    cart.addItem('1', 'Apple', 100.0);
    cart.removeItem('1');
    expect(cart.totalItems, 0);
    expect(cart.subtotal, 0.0);
  });

  test('Clear cart', () {
    cart.addItem('1', 'Apple', 100.0);
    cart.addItem('2', 'Banana', 50.0);
    cart.clearCart();
    expect(cart.totalItems, 0);
    expect(cart.subtotal, 0.0);
  });

  test('Total discount calculation', () {
    cart.addItem('1', 'Apple', 100.0, discount: 0.1);
    cart.addItem('2', 'Banana', 50.0, discount: 0.2);
    expect(cart.totalDiscount, 100*0.1 + 50*0.2);
  });

  test('Total amount includes discount', () {
    cart.addItem('1', 'Apple', 100.0, discount: 0.1);
    cart.addItem('2', 'Banana', 50.0, discount: 0.2);
    expect(cart.totalAmount, cart.subtotal - cart.totalDiscount);
  });
}
