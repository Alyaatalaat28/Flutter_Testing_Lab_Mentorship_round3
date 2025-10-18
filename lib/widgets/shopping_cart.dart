import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/models/shopping_cart_model.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final ShoppingCartModel _cartModel = ShoppingCartModel();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  _cartModel.addItem(
                    '1',
                    'Apple iPhone',
                    999.99,
                    discount: 0.1,
                  );
                }),
                child: const Text('Add iPhone'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _cartModel.addItem(
                    '2',
                    'Samsung Galaxy',
                    899.99,
                    discount: 0.15,
                  );
                }),
                child: const Text('Add Galaxy'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _cartModel.addItem('3', 'iPad Pro', 1099.99);
                }),
                child: const Text('Add iPad'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _cartModel.addItem(
                    '1',
                    'Apple iPhone',
                    999.99,
                    discount: 0.1,
                  );
                }),
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
                    Text('Total Items: ${_cartModel.totalItems}'),
                    ElevatedButton(
                      onPressed: () => _cartModel.clearCart(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Clear Cart'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Subtotal: \$${_cartModel.subtotal.toStringAsFixed(2)}'),
                Text(
                  'Total Discount: \$${_cartModel.totalDiscount.toStringAsFixed(2)}',
                ),
                const Divider(),
                Text(
                  'Total Amount: \$${_cartModel.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _cartModel.items.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _cartModel.items.length,
                  itemBuilder: (context, index) {
                    final item = _cartModel.items[index];
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
                            Text(
                              'Item Total: \$${itemTotal.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                _cartModel.updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                );
                              }),
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
                              onPressed: () => setState(() {
                                _cartModel.updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                );
                              }),
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _cartModel.removeItem(item.id);
                              }),
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
    );
  }
}
