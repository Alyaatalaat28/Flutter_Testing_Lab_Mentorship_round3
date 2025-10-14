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

  void addItem(CartItem cartItem) {
    setState(() {
      final existingIndex = _items.indexWhere((item) => item.id == cartItem.id);
      //if cartItem isn't found in the list, add it to the list
      if (existingIndex != -1) {
        _items[existingIndex].quantity += 1;
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
    });
  }

  void removeItem(String id) {
    setState(() {
      _items.removeWhere((item) {
        return item.id == id;
      });
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

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  double get totalDiscount => _items.fold(
    0,
    (sum, item) => sum + item.price * item.discount * item.quantity,
  );

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  final List<Map<String, dynamic>> products = [
    {
      'label': 'Add iPhone',
      'item': CartItem(
        id: '1',
        name: 'Apple iPhone',
        price: 999.99,
        discount: 0.1,
      ),
    },
    {
      'label': 'Add Galaxy',
      'item': CartItem(
        id: '2',
        name: 'Samsung Galaxy',
        price: 899.99,
        discount: 0.15,
      ),
    },
    {
      'label': 'Add iPad',
      'item': CartItem(id: '3', name: 'iPad Pro', price: 1099.99),
    },
    {
      'label': 'Add iPhone Again', // نفس المنتج لكن label مختلف
      'item': CartItem(
        id: '1',
        name: 'Apple iPhone',
        price: 999.99,
        discount: 0.1,
      ),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: products
              .map(
                (product) => ElevatedButton(
                  onPressed: () => addItem(product["item"]),
                  child: Text(product["label"]),
                ),
              )
              .toList(),
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
              Text('Total Discount: \$${totalDiscount.toStringAsFixed(2)}'),
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
                  final itemTotal = item.price * item.quantity;

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
