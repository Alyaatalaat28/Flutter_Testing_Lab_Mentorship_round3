import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/shopping_cubit.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/list_of_products_widget.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/product_button_widget.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/total_items_widget.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingCubit>();
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      builder: (context, state) {
        return Column(
          children: [
            ProductsButtonWidet(cubit: cubit),
            const SizedBox(height: 16),
            TotalItemsWidget(
              onPressed: cubit.clearCart,
              subtotal: cubit.subtotal,
              totalAmount: cubit.totalAmount,
              totalDiscount: cubit.totalDiscount,
              totalItems: cubit.totalItems,
            ),
            const SizedBox(height: 16),
            cubit.items.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListOfProductsWidget(cubit: cubit),
          ],
        );
      },
    );
  }
}
