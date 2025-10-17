import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/shopping_cubit.dart';

class ProductsButtonWidet extends StatelessWidget {
  const ProductsButtonWidet({super.key, required this.cubit});

  final ShoppingCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: () =>
              cubit.addItem('1', 'Apple iPhone', 1000.00, discount: 0.1),
          child: const Text('Add iPhone'),
        ),
        ElevatedButton(
          onPressed: () =>
              cubit.addItem('2', 'Samsung Galaxy', 600.00, discount: 0.15),
          child: const Text('Add Galaxy'),
        ),
        ElevatedButton(
          onPressed: () => cubit.addItem('3', 'iPad Pro', 1100.00),
          child: const Text('Add iPad'),
        ),
        ElevatedButton(
          onPressed: () =>
              cubit.addItem('1', 'Apple iPhone', 2000.00, discount: 0.1),
          child: const Text('Add iPhone Again'),
        ),
      ],
    );
  }
}
