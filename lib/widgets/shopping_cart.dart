import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final CartService _cart = CartService();

  void _addSampleItem(String id, String name, double price, {double discount = 0.0}) {
    setState(() {
      _cart.addItem(id: id, name: name, price: price, discount: discount);
    });
  }

  void _updateQuantity(String id, int newQty) {
    setState(() {
      _cart.updateQuantity(id, newQty);
    });
  }

  void _removeItem(String id) {
    setState(() {
      _cart.removeItem(id);
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clearCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => _addSampleItem('1', 'Apple iPhone', 999.99, discount: 0.1),
              child: const Text('Add iPhone'),
            ),
            ElevatedButton(
              onPressed: () => _addSampleItem('2', 'Samsung Galaxy', 899.99, discount: 0.15),
              child: const Text('Add Galaxy'),
            ),
            ElevatedButton(
              onPressed: () => _addSampleItem('3', 'iPad Pro', 1099.99),
              child: const Text('Add iPad'),
            ),
            ElevatedButton(
              onPressed: () => _addSampleItem('1', 'Apple iPhone', 999.99, discount: 0.1),
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
                  Text('Total Items: ${_cart.totalItems}'),
                  ElevatedButton(
                    onPressed: _clearCart,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Clear Cart'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Subtotal: \$${_cart.subtotal.toStringAsFixed(2)}'),
              Text('Total Discount: \$${_cart.totalDiscount.toStringAsFixed(2)}'),
              const Divider(),
              Text(
                'Total Amount: \$${_cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _cart.items.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _cart.items.length,
                itemBuilder: (context, index) {
                  final item = _cart.items[index];
                  final itemTotal = item.price * item.quantity;
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: \$${item.price.toStringAsFixed(2)} each'),
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
                            onPressed: () => _updateQuantity(item.id, item.quantity - 1),
                            icon: const Icon(Icons.remove),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                            child: Text('${item.quantity}'),
                          ),
                          IconButton(
                            onPressed: () => _updateQuantity(item.id, item.quantity + 1),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () => _removeItem(item.id),
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
