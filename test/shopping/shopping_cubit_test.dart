import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/shopping_cubit.dart'; 

void main() {
  late ShoppingCubit cubit;

  setUp(() {
    cubit = ShoppingCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be ShoppingInitial', () {
    expect(cubit.state, isA<ShoppingInitial>());
  });

  test('addItem should add a new item', () {
    cubit.addItem('1', 'iPhone', 1000, discount: 0.1);
    expect(cubit.items.length, 1);
    expect(cubit.items.first.name, 'iPhone');
    expect(cubit.items.first.discount, 0.1);
  });

  test('addItem should increase quantity if item already exists', () {
    cubit.addItem('1', 'iPhone', 1000);
    cubit.addItem('1', 'iPhone', 1000);
    expect(cubit.items.first.quantity, 2);
  });

  test('removeItem should remove item by id', () {
    cubit.addItem('1', 'iPhone', 1000);
    cubit.removeItem('1');
    expect(cubit.items.isEmpty, true);
  });

  test('updateQuantity should change quantity correctly', () {
    cubit.addItem('1', 'iPhone', 1000);
    cubit.updateQuantity('1', 3);
    expect(cubit.items.first.quantity, 3);
  });

  test('clearCart should remove all items', () {
    cubit.addItem('1', 'iPhone', 1000);
    cubit.addItem('2', 'Galaxy', 800);
    cubit.clearCart();
    expect(cubit.items.isEmpty, true);
  });

  group('Total calculations', () {
    setUp(() {
      cubit.addItem('1', 'iPhone', 1000, discount: 0.1);
      cubit.addItem('2', 'Galaxy', 2000, discount: 0.15);
    });

    test('subtotal should calculate correctly', () {
      expect(cubit.subtotal, 3000);
    });

    test('totalDiscount should calculate correctly', () {
      // iPhone discount = 1000 * 0.1 = 100
      // Galaxy discount = 2000 * 0.15 = 300
      expect(cubit.totalDiscount, 400);
    });

    test('totalAmount should calculate correctly', () {
      // 3000 - 400 = 2600
      expect(cubit.totalAmount, 2600);
    });

    test('totalItems should sum all quantities', () {
      expect(cubit.totalItems, 2);
    });
  });
}
