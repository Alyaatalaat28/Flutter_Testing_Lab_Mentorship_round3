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

class CartRepo {
  final List<CartItem> items = [];

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    final item = items.indexWhere((item) => item.id == id);
    if (item != -1) {
      updateQuantity(id, items[item].quantity + 1);
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

  double get subtotal {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalDiscount {
    double discount = 0;
    for (var item in items) {
      if (item.discount == 0) continue;
      discount += (item.price * item.quantity) * item.discount;
    }
    return discount;
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final cartRepo = CartRepo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                cartRepo.addItem('1', 'Apple iPhone', 999.99, discount: 0.1);
              }),
              child: const Text('Add iPhone'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                cartRepo.addItem('2', 'Samsung Galaxy', 899.99, discount: 0.15);
              }),

              child: const Text('Add Galaxy'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                cartRepo.addItem('3', 'iPad Pro', 1099.99);
              }),
              child: const Text('Add iPad'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                cartRepo.addItem('1', 'Apple iPhone', 999.99, discount: 0.1);
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
                  Text('Total Items: ${cartRepo.totalItems}'),
                  ElevatedButton(
                    onPressed: () => setState(() => cartRepo.clearCart()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear Cart'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Subtotal: \$${cartRepo.subtotal.toStringAsFixed(2)}'),
              Text(
                'Total Discount: \$${cartRepo.totalDiscount.toStringAsFixed(2)}',
              ),
              const Divider(),
              Text(
                'Total Amount: \$${cartRepo.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        cartRepo.items.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cartRepo.items.length,
                itemBuilder: (context, index) {
                  final item = cartRepo.items[index];
                  final itemTotal =
                      (item.price * item.quantity) -
                      (item.price * item.quantity * item.discount);

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
                            onPressed: () => setState(() {
                              cartRepo.updateQuantity(
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
                            onPressed: () {
                              setState(() {});
                              cartRepo.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {});

                              cartRepo.removeItem(item.id);
                            },
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