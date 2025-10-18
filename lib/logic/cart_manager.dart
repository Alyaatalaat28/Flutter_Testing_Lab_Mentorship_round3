import '../models/cart_item.dart';

class CartManager {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    // Clamp discount to [0.0, 1.0] which prevent negative prices
    discount = discount.clamp(0.0, 1.0);
    price = price < 0 ? 0 : price;
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      // If item exists, increment its quantity for avoid duplicate items
      final existing = _items[index];
      _items[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      // Add new item if not found in the cart
      _items.add(
        CartItem(id: id, name: name, price: price, discount: discount),
      );
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        // Remove item if quantity set to 0 or lower
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
      }
    }
  }

  void clear() {
    _items.clear();
  }

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  double get totalDiscount {
    // Clamp discount between 0 and 1 to prevent negative prices
    return _items.fold(0, (sum, item) {
      final itemDiscount = item.discount.clamp(0.0, 1.0);
      return sum + item.price * item.quantity * itemDiscount;
    });
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
