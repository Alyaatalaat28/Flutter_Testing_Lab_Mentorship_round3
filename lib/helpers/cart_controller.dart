import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final double discount; // 0.0 to 1.0
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.discount = 0.0,
    this.quantity = 1,
  });

  double get totalPrice => (price * quantity) - (price * discount * quantity);
}

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(
    String id,
    String name,
    double price, {
    double discount = 0.0,
    int quantity = 1,
  }) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: id,
          name: name,
          price: price,
          discount: discount,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get totalDiscount => _items.fold(
    0,
    (sum, item) => sum + (item.price * item.discount * item.quantity),
  );

  double get totalAmount => subtotal - totalDiscount;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}
