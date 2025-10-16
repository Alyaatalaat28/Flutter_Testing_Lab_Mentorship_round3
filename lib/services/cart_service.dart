import '../models/cart_item.dart';

class CartService {
  final List<CartItem> _items = [];

  // Return an immutable copy
  List<CartItem> get items => List.unmodifiable(_items);

  /// Add item — if item with same id exists, increase its quantity.
  /// quantityToAdd must be >= 1.
  void addItem({
    required String id,
    required String name,
    required double price,
    int quantityToAdd = 1,
    double discount = 0.0, // fraction 0..1
    int maxQuantity = 9999,
  }) {
    if (quantityToAdd <= 0) return;

    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final newQuantity = (_items[idx].quantity + quantityToAdd).clamp(1, maxQuantity);
      _items[idx].quantity = newQuantity;
      // If discount changed for same id, we keep the existing discount (business decision).
    } else {
      final q = quantityToAdd.clamp(1, maxQuantity);
      _items.add(CartItem(id: id, name: name, price: price, quantity: q, discount: discount.clamp(0.0, 1.0)));
    }
  }

  /// Remove all entries with this id
  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
  }

  /// Update quantity — if newQuantity <= 0, remove the item.
  void updateQuantity(String id, int newQuantity) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    if (newQuantity <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx].quantity = newQuantity;
    }
  }

  void clearCart() => _items.clear();

  /// Sum price * quantity (before discounts)
  double get subtotal {
    return _items.fold(0.0, (sum, i) => sum + (i.price * i.quantity));
  }

  /// Sum of monetary discounts: price * quantity * discountFraction
  double get totalDiscount {
    return _items.fold(0.0, (sum, i) => sum + (i.price * i.quantity * (i.discount.clamp(0.0, 1.0))));
  }

  /// Total after applying discounts (cannot be negative)
  double get totalAmount {
    final amt = subtotal - totalDiscount;
    return amt < 0 ? 0.0 : amt;
  }

  /// Total items count (sum of quantities)
  int get totalItems {
    return _items.fold(0, (sum, i) => sum + i.quantity);
  }
}
