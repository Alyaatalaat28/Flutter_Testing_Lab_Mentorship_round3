import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/functions/cart/add_to_cart.dart';
import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/functions/cart/remove_item_cart.dart';
import 'package:flutter_testing_lab/functions/cart/subtotal_cart.dart';
import 'package:flutter_testing_lab/functions/cart/total_amount_cart.dart';
import 'package:flutter_testing_lab/functions/cart/total_discount_cart.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  late AddItem shoppingCartDefault;
  // late CartItem cartItem;
  late List<CartItem> listProduct;
  late Subtotal subtotal;

  // late TotalAmount totalAmount;
  //late TotalDiscountCart totalDiscountCart;

  // late TotalDiscount totalDiscount;
  late TotalAmount totalAmountCart;
  late RemoveItem removeItem;

  group("group add product", () {
    setUp(() {
      listProduct = [];
      subtotal = SubtotalCart();
      // totalDiscount = TotalDiscountCart();
      totalAmountCart = TotalAmountCart(
        subtotalCart: SubtotalCart(),
        totalDiscount: TotalDiscountCart(),
      );
      removeItem = RemoveItemCart();

      shoppingCartDefault = AddToCart(cartItem: listProduct);
    });

    test("clears the cart and results in an empty list", () {
      listProduct.clear();
      expect(listProduct, []);
    });

    test("Removes the item with the given ID from the product list", () {
      listProduct.addAll([
        CartItem(id: '0', name: 'Samsung Galaxy', price: 999.9, discount: 0.1),
        CartItem(id: '1', name: 'Samsung Galaxy', price: 999.9, discount: 0.1),
        CartItem(id: '2', name: 'Samsung Galaxy', price: 999.9, discount: 0.1),
        CartItem(id: '3', name: 'Samsung Galaxy', price: 999.9, discount: 0.1),
        CartItem(id: '4', name: 'Samsung Galaxy', price: 999.9, discount: 0.1),
      ]);
      removeItem.removeItem('3', items: listProduct);

      bool delete = listProduct.any((test) => test.id == '3');
      expect(delete, false);
    });

    test(
      "calculates total amount correctly after applying discounts to all cart items",
      () {
        listProduct.addAll([
          CartItem(
            id: '0',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(
            id: '1',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(
            id: '2',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(
            id: '3',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(
            id: '4',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(id: '5', name: 'iPad Pro', price: 1099.99, discount: 0.1),
        ]);
        double ff = totalAmountCart.totalAmount(carts: listProduct);
        expect(ff.toStringAsFixed(2), "5489.54");
      },
    );
    test(
      "should calculate subtotal as sum of (price * quantity) for all cart items",
      () {
        listProduct.addAll([
          CartItem(
            id: '0',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(
            id: '1',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
          CartItem(
            id: '2',
            name: 'Samsung Galaxy',
            price: 999.9,
            discount: 0.1,
          ),
        ]);
        subtotal.subtotal(listProduct);
        expect(subtotal.subtotal(listProduct), 2999.7);
      },
    );

    testWidgets("description", (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      shoppingCartDefault.addItem(
        CartItem(id: '1', name: 'Apple iPhone', price: 999.9, discount: 0.1),
      );

      await widgetTester.pump();
      shoppingCartDefault.addItem(
        CartItem(id: '1', name: 'Apple iPhone', price: 999.9, discount: 0.1),
      );

      expect(listProduct.length, 1);
    });
    test('Check if an item exists', () {
      shoppingCartDefault.addItem(
        CartItem(id: '1', name: 'Apple iPhone', price: 999.9, discount: 0.1),
      );

      expect(listProduct.length, 1);
      bool f = listProduct.any((test) => test.id == '1');
      expect(f, true);
    });
  });
}
