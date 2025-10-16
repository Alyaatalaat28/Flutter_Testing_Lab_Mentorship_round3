import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/functions/cart/add_to_cart.dart';
import 'package:flutter_testing_lab/functions/cart/cart.dart';
import 'package:flutter_testing_lab/functions/cart/remove_item_cart.dart';
import 'package:flutter_testing_lab/functions/cart/subtotal_cart.dart';
import 'package:flutter_testing_lab/functions/cart/total_amount_cart.dart';
import 'package:flutter_testing_lab/functions/cart/total_discount_cart.dart';

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

  late AddItem shoppingCart;
  late Subtotal subtotal;
  late TotalDiscountCart totalDiscountCart;
  late TotalAmount totalAmountCart;
  late RemoveItem removeItem;

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

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  late TotalDiscount totalDiscount;

  @override
  void initState() {
    shoppingCart = AddToCart(cartItem: _items);
    subtotal = SubtotalCart();
    totalDiscountCart = TotalDiscountCart();
    totalAmountCart = TotalAmountCart(
      subtotalCart: subtotal,
      totalDiscount: totalDiscountCart,
    );
    removeItem = RemoveItemCart();

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
              onPressed: () {
                setState(() {
                  shoppingCart.addItem(
                    CartItem(
                      id: '1',
                      name: 'Apple iPhone',
                      price: 999.9,
                      discount: 0.1,
                    ),
                  );
                });
              },

              child: const Text('Add iPhone'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                shoppingCart = AddToCart(cartItem: _items);
                shoppingCart.addItem(
                  CartItem(
                    id: '2',
                    name: 'Samsung Galaxy',
                    price: 999.9,
                    discount: 0.1,
                  ),
                );
              }),

              child: const Text('Add Galaxy'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                shoppingCart.addItem(
                  CartItem(
                    id: '3',
                    name: 'iPad Pro',
                    price: 1099.99,
                    discount: 0.1,
                  ),
                );
              }),

              child: const Text('Add iPad'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                shoppingCart.addItem(
                  CartItem(
                    id: '1',
                    name: 'Apple iPhone',
                    price: 999.9,
                    discount: 0.1,
                  ),
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
              Text(
                'Subtotal: \$${subtotal.subtotal(_items).toStringAsFixed(2)}',
              ),
              Text(
                'Total Discount: \$${totalAmountCart.totalAmount(carts: _items).toStringAsFixed(2)}',
              ),
              const Divider(),
              // Text(
              //   'Total Amount: \$${totalAmount}',
              //   // ${totalAmount.toStringAsFixed(2)}',
              //   style: const TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              // ),
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
                            key: Key("removeItem"),
                            onPressed: () {
                              setState(() {
                                removeItem.removeItem(item.id, items: _items);
                              });
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
