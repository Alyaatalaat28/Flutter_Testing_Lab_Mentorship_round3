import 'dart:collection';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  double discount; // percentage as 0.0 - 1.0

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  }) {
    // normalize values
    if (discount.isNaN || discount.isInfinite) discount = 0.0;
    if (discount < 0) discount = 0.0;
    if (discount > 1) discount = 1.0;
    if (quantity < 1) quantity = 1;
  }
}

class CartModel {
  final List<CartItem> _items = [];
  final int maxQuantity;

  CartModel({this.maxQuantity = 100});

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  void addItem(String id, String name, double price,
      {double discount = 0.0, int quantity = 1}) {
    if (quantity <= 0) return;
    discount = discount.clamp(0.0, 1.0);

    final index = _items.indexWhere((it) => it.id == id);
    if (index != -1) {
      final existing = _items[index];
      existing.quantity = (existing.quantity + quantity).clamp(1, maxQuantity);
      existing.discount = discount; // update discount if provided
    } else {
      final qty = quantity.clamp(1, maxQuantity);
      _items.add(CartItem(
        id: id,
        name: name,
        price: price,
        quantity: qty,
        discount: discount,
      ));
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = newQuantity.clamp(1, maxQuantity);
    }
  }

  void clear() => _items.clear();

  double get subtotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalDiscount {
    double discount = 0;
    for (var item in _items) {
      final d = item.discount.clamp(0.0, 1.0);
      discount += item.price * item.quantity * d;
    }
    return discount;
  }

  double get totalAmount {
    final amount = subtotal - totalDiscount;
    if (amount.isNaN || amount.isNegative) return 0.0;
    return amount;
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}
