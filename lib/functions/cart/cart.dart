import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

// abstract class ShoppingCartDefault {
//   void addItem(CartItem cartItem);
// }

abstract class AddItem {
  void addItem(CartItem cartItem);
}

abstract class Subtotal {
  double subtotal(List<CartItem> carts);
}

abstract class TotalDiscount {
  double totalDiscount({required List<CartItem> carts});
}

abstract class TotalAmount {
  double totalAmount({required List<CartItem> carts});
}

abstract class RemoveItem {
  void removeItem(String id, {required List<CartItem> items});
}
