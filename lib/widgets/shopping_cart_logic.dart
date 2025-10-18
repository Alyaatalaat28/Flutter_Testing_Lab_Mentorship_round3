import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // Discount percentage (0.0 to 1.0)

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    double? discount,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity &&
        other.discount == discount;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, price, quantity, discount);
  }
}

class CartManager with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem cartItem) {
    final existingIndex = _items.indexWhere((item) => item.id == cartItem.id);

    if (existingIndex != -1) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(
        CartItem(
          id: cartItem.id,
          name: cartItem.name,
          price: cartItem.price,
          quantity: 1,
          discount: cartItem.discount,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get totalDiscount => _items.fold(
    0,
    (sum, item) => sum + item.price * item.discount * item.quantity,
  );

  double get totalAmount => subtotal - totalDiscount;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  // Helper method for testing
  @visibleForTesting
  void setItemsForTesting(List<CartItem> testItems) {
    _items.clear();
    _items.addAll(testItems);
    notifyListeners();
  }
}
