import 'package:flutter/material.dart';

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

  // Helper method to calculate discounted price
  double get discountedPrice {
    return price * (1.0 - discount);
  }

  // Helper method to calculate total for this item
  double get totalPrice {
    return discountedPrice * quantity;
  }

  // Helper method to calculate discount amount for this item
  double get discountAmount {
    return (price * discount) * quantity;
  }
}

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final List<CartItem> _items = [];

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    setState(() {
      // Check if item already exists
      final existingItemIndex = _items.indexWhere((item) => item.id == id);

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        _items[existingItemIndex].quantity += 1;
      } else {
        // Add new item
        _items.add(
          CartItem(id: id, name: name, price: price, discount: discount),
        );
      }
    });
  }

  void removeItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  void updateQuantity(String id, int newQuantity) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        if (newQuantity <= 0) {
          _items.removeAt(index);
        } else {
          // Add quantity limit (optional, but good practice)
          const maxQuantity = 999;
          _items[index].quantity = newQuantity.clamp(1, maxQuantity);
        }
      }
    });
  }

  void clearCart() {
    setState(() {
      _items.clear();
    });
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get totalDiscount {
    return _items.fold(0.0, (sum, item) => sum + item.discountAmount);
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      addItem('1', 'Apple iPhone', 999.99, discount: 0.1),
                  child: const Text('Add iPhone'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      addItem('2', 'Samsung Galaxy', 899.99, discount: 0.15),
                  child: const Text('Add Galaxy'),
                ),
                ElevatedButton(
                  onPressed: () => addItem('3', 'iPad Pro', 1099.99),
                  child: const Text('Add iPad'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      addItem('1', 'Apple iPhone', 999.99, discount: 0.1),
                  child: const Text('Add iPhone Again'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cart Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total Items: $totalItems',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: clearCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clear Cart'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  Text(
                    'Total Discount: -\$${totalDiscount.toStringAsFixed(2)}',
                  ),
                  const Divider(),
                  Text(
                    'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cart Items List
            _items.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Cart is empty',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : Column(
                    children: _items.map((item) {
                      final itemTotal = item.totalPrice;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Price: \$${item.price.toStringAsFixed(2)} each',
                                        ),
                                        if (item.discount > 0) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Discount: ${(item.discount * 100).toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                        Text(
                                          'Item Total: \$${itemTotal.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity Controls - Simplified to prevent overflow
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () => updateQuantity(
                                              item.id,
                                              item.quantity - 1,
                                            ),
                                            icon: const Icon(Icons.remove),
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 36,
                                              minHeight: 36,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => updateQuantity(
                                              item.id,
                                              item.quantity + 1,
                                            ),
                                            icon: const Icon(Icons.add),
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 36,
                                              minHeight: 36,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        height: 36,
                                        child: ElevatedButton(
                                          onPressed: () => removeItem(item.id),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
