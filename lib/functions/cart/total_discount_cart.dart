import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

class TotalDiscountCart implements TotalDiscount {
  @override
  double totalDiscount({required List<CartItem> carts}) {
    double discount = 0;
    for (var item in carts) {
      // discount += item.discount * item.quantity;
      discount += (item.price * item.discount) * item.quantity;
    }
    return discount;
  }
}
