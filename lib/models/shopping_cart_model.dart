class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // نسبة خصم من 0.0 إلى 1.0

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
}

class ShoppingCartModel {
  final List<CartItem> _items = [];
  final int maxQuantity;
  final int minQuantity;

  ShoppingCartModel({this.maxQuantity = 99, this.minQuantity = 1});

  List<CartItem> get items => List.unmodifiable(_items);

  // Add item: if exists -> update quantity (respect max), else add
  void addItem(
    String id,
    String name,
    double price, {
    double discount = 0.0,
    int quantity = 1,
  }) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final existing = _items[idx];
      final newQty = (existing.quantity + quantity).clamp(
        minQuantity,
        maxQuantity,
      );
      _items[idx].quantity = newQty;
    } else {
      final qty = quantity.clamp(minQuantity, maxQuantity);
      _items.add(
        CartItem(
          id: id,
          name: name,
          price: price,
          quantity: qty,
          discount: discount,
        ),
      );
    }
  }

  // Remove entire item
  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
  }

  // Update quantity (if newQuantity <= 0 remove item), clamp to [minQuantity, maxQuantity]

  void updateQuantity(String id, int newQuantity) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    if (newQuantity <= 0) {
      _items.removeAt(idx);
      return;
    }
    _items[idx].quantity = newQuantity.clamp(minQuantity, maxQuantity);
  }

  void clearCart() => _items.clear();

  double get subtotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // totalDiscount = sum(price * quantity * discount)

  double get totalDiscount {
    double discount = 0;
    for (var item in _items) {
      final d = item.discount.clamp(0.0, 1.0);
      discount += item.price * item.quantity * d;
    }
    return discount;
  }

  // totalAmount = subtotal - totalDiscount

  double get totalAmount {
    final amount = subtotal - totalDiscount;
    return amount < 0 ? 0.0 : amount;
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}
