import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/helpers/cart_controller.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final CartController _controller = CartController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _controller.items;

    return Scaffold(
      appBar: AppBar(title: const Text('🛒 Shopping Cart')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.addItem(
                    '1',
                    'Apple iPhone',
                    999.99,
                    discount: 0.1,
                  ),
                  child: const Text('Add iPhone'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.addItem(
                    '2',
                    'Samsung Galaxy',
                    899.99,
                    discount: 0.15,
                  ),
                  child: const Text('Add Galaxy'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _controller.addItem('3', 'iPad Pro', 1099.99),
                  child: const Text('Add iPad'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSummary(),

            const SizedBox(height: 16),
            items.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('Your cart is empty!'),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                              ),
                              if (item.discount > 0)
                                Text(
                                  'Discount: ${(item.discount * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              Text(
                                'Total: \$${item.totalPrice.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _controller.updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                ),
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                key: ValueKey('quantity_$index'),
                                '${item.quantity}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () => _controller.updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                ),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _controller.removeItem(item.id),
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
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items: ${_controller.totalItems}',
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: _controller.clearCart,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const Divider(),
            _buildRow('Subtotal', _controller.subtotal),
            _buildRow('Discount', _controller.totalDiscount),
            const Divider(),
            _buildRow(
              'Total',
              _controller.totalAmount,
              bold: true,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
