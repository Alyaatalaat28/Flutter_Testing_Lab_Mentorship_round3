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
}

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final List<CartItem> _items = [];

  // ⭐️ FIX: Add public getter for testing ⭐️
  List<CartItem> get items => _items;

  // 🛠️ FIX 1: Increment quantity if item exists, otherwise add new item.
  void addItem(String id, String name, double price, {double discount = 0.0}) {
    setState(() {
      final existingItemIndex = _items.indexWhere((item) => item.id == id);

      if (existingItemIndex != -1) {
        // Increment quantity for existing item
        _items[existingItemIndex].quantity++;
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
          _items[index].quantity = newQuantity;
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
    double total = 0;
    for (var item in _items) {
      // Calculates the base cost before discount
      total += item.price * item.quantity;
    }
    return total;
  }

  // 🛠️ FIX 2: Calculate the total MONETARY discount.
  double get totalDiscount {
    double discountAmount = 0;
    for (var item in _items) {
      // Monetary discount per item = (price * discount_percentage) * quantity
      discountAmount += (item.price * item.discount) * item.quantity;
    }
    return discountAmount;
  }

  // 🛠️ FIX 3: Total amount is Subtotal MINUS Total Discount.
  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Items: $totalItems'),
                  ElevatedButton(
                    onPressed: clearCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear Cart'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
              // Display discount as a negative number for clarity
              Text('Total Discount: -\$${totalDiscount.toStringAsFixed(2)}'),
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
        _items.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  // Item total needs to be the discounted total for the line item
                  final discountedPrice = item.price * (1 - item.discount);
                  final itemTotal = discountedPrice * item.quantity;

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \$${item.price.toStringAsFixed(2)} each',
                          ),
                          if (item.discount > 0)
                            Text(
                              'Discount: ${(item.discount * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.green),
                            ),
                          // Display the final item total after discount
                          Text('Item Total: \$${itemTotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                updateQuantity(item.id, item.quantity - 1),
                            icon: const Icon(Icons.remove),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('${item.quantity}'),
                          ),
                          IconButton(
                            onPressed: () =>
                                updateQuantity(item.id, item.quantity + 1),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () => removeItem(item.id),
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
