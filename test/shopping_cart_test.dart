import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // 0.0 to 1.0

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

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    setState(() {
      final existingIndex = _items.indexWhere((item) => item.id == id);
      if (existingIndex != -1) {
        _items[existingIndex].quantity += 1;
      } else {
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
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalDiscount {
    double discountAmount = 0;
    for (var item in _items) {
      discountAmount += (item.price * item.discount) * item.quantity;
    }
    return discountAmount;
  }

  double get totalAmount {
    return subtotal - totalDiscount; // ✅ Corrected logic
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
              Text('Discount: -\$${totalDiscount.toStringAsFixed(2)}'),
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
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final itemTotal =
                      (item.price - (item.price * item.discount)) *
                          item.quantity;

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
                            onPressed: () =>
                                updateQuantity(item.id, item.quantity - 1),
                            icon: const Icon(Icons.remove),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
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

// Simple host to avoid layout overflows in tests.
Widget _host(Widget child) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        )),
      ),
    );

void main() {
  group('ShoppingCart widget', () {
    testWidgets('initial state shows empty cart and zero totals',
        (tester) async {
      await tester.pumpWidget(_host(const ShoppingCart()));

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text('Subtotal: \$0.00'), findsOneWidget);
      expect(find.text('Discount: -\$0.00'), findsOneWidget);
      expect(find.text('Total Amount: \$0.00'), findsOneWidget);
    });

    testWidgets('adding same item twice increments quantity and totals',
        (tester) async {
      await tester.pumpWidget(_host(const ShoppingCart()));

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add iPhone Again')); // same id = '1'
      await tester.pump();

      // Totals after 2 iPhones:
      // subtotal = 999.99 * 2 = 1999.98
      // discount = (999.99 * 0.1) * 2 = 199.998 -> $200.00
      // total = 1799.982 -> $1799.98
      expect(find.text('Total Items: 2'), findsOneWidget);
      expect(find.text('Subtotal: \$1999.98'), findsOneWidget);
      expect(find.text('Discount: -\$200.00'), findsOneWidget);
      expect(find.text('Total Amount: \$1799.98'), findsOneWidget);

      // Item section
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Discount: 10%'), findsOneWidget);
      expect(find.text('Item Total: \$1799.98'), findsOneWidget);

      // Quantity badge shows "2" inside the iPhone tile.
      final iphoneTile = find.widgetWithText(ListTile, 'Apple iPhone');
      expect(
        find.descendant(of: iphoneTile, matching: find.text('2')),
        findsOneWidget,
      );
    });

    testWidgets('adding different item updates subtotal, discount and count',
        (tester) async {
      await tester.pumpWidget(_host(const ShoppingCart()));
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add iPhone Again')); // now iPhone qty=2
      await tester.pump();
      await tester.tap(find.text('Add Galaxy')); // one Galaxy
      await tester.pump();

      // subtotal = 999.99*2 + 899.99 = 2899.97
      // discount = 999.99*0.1*2 + 899.99*0.15 = 199.998 + 134.9985 = 334.9965 -> $335.00
      // total = 2899.97 - 334.9965 = 2564.9735 -> $2564.97
      expect(find.text('Total Items: 3'), findsOneWidget);
      expect(find.text('Subtotal: \$2899.97'), findsOneWidget);
      expect(find.text('Discount: -\$335.00'), findsOneWidget);
      expect(find.text('Total Amount: \$2564.97'), findsOneWidget);

      // Galaxy tile present with its percent label
      expect(find.text('Samsung Galaxy'), findsOneWidget);
      expect(find.text('Discount: 15%'), findsOneWidget);
    });

    testWidgets('minus to zero removes the item', (tester) async {
      await tester.pumpWidget(_host(const ShoppingCart()));
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      final ipadTile = find.widgetWithText(ListTile, 'iPad Pro');
      expect(ipadTile, findsOneWidget);

      // Press minus once: quantity 1 -> updateQuantity(..., 0) -> removed
      final minusBtn = find.descendant(
        of: ipadTile,
        matching: find.byIcon(Icons.remove),
      );
      await tester.tap(minusBtn);
      await tester.pump();

      expect(find.text('iPad Pro'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('delete button removes the item explicitly', (tester) async {
      await tester.pumpWidget(_host(const ShoppingCart()));
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      final galaxyTile = find.widgetWithText(ListTile, 'Samsung Galaxy');
      final deleteBtn = find.descendant(
        of: galaxyTile,
        matching: find.byIcon(Icons.delete),
      );
      await tester.tap(deleteBtn);
      await tester.pump();

      expect(find.text('Samsung Galaxy'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('Clear Cart empties list and resets totals', (tester) async {
      await tester.pumpWidget(_host(const ShoppingCart()));
      await tester.tap(find.text('Add iPhone'));
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      expect(find.text('Total Items: 2'), findsOneWidget);

      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text('Subtotal: \$0.00'), findsOneWidget);
      expect(find.text('Discount: -\$0.00'), findsOneWidget);
      expect(find.text('Total Amount: \$0.00'), findsOneWidget);
    });
  });
}
