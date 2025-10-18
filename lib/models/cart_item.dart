class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final double discount;

  const CartItem({
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

