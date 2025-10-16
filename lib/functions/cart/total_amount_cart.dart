import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/functions/cart/total_discount_cart.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

class TotalAmountCart implements TotalAmount {
  final TotalDiscountCart totalDiscount;
  final Subtotal subtotalCart;
  TotalAmountCart({required this.subtotalCart, required this.totalDiscount});
  @override
  double totalAmount({required List<CartItem> carts}) {
    return (subtotalCart.subtotal(carts) -
        totalDiscount.totalDiscount(carts: carts));
  }
}
