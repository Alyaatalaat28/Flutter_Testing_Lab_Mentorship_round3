class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });
}

class CartManager {
  final List<CartItem> items = [];

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      items[index].quantity += 1;
    } else {
      items.add(CartItem(id: id, name: name, price: price, discount: discount));
    }
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = newQuantity;
      }
    }
  }

  void clearCart() {
    items.clear();
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  double get totalDiscount =>
      items.fold(0.0, (sum, item) => sum + (item.price * item.discount * item.quantity));

  double get totalAmount => subtotal - totalDiscount;
}
