import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

class AddToCart implements AddItem {
  final List<CartItem> _cartItem;
  AddToCart({required List<CartItem> cartItem}) : _cartItem = cartItem;
  @override
  void addItem(CartItem cartItem) {
    int index = _cartItem.indexWhere((test) => test.id == cartItem.id);
    if (index != -1) {
      _cartItem.last.quantity++;
    } else {
      _cartItem.add(cartItem);
    }
  }
}
