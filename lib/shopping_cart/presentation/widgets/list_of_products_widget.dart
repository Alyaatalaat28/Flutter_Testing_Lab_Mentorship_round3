import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/shopping_cubit.dart';

class ListOfProductsWidget extends StatelessWidget {
  const ListOfProductsWidget({super.key, required this.cubit});

  final ShoppingCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cubit.items.length,
      itemBuilder: (context, index) {
        final item = cubit.items[index];
        final itemTotal =
            (item.price - (item.price * item.discount)) * item.quantity;

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
                      cubit.updateQuantity(item.id, item.quantity - 1),
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
                      cubit.updateQuantity(item.id, item.quantity + 1),
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => cubit.removeItem(item.id),
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
