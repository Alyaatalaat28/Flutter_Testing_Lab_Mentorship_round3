import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

class SubtotalCart implements Subtotal {
  @override
  double subtotal(List<CartItem> carts) {
    double total = 0;

    for (var item in carts) {
      total += (item.price * item.quantity);
    }

    return total;
  }
}
