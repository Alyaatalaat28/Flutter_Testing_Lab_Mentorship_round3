import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

class RemoveItemCart implements RemoveItem {
  @override
  void removeItem(String id, {required List<CartItem> items}) {
    items.removeWhere((item) => item.id == id);
  }
}
