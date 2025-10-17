import 'package:flutter/material.dart';

class TotalItemsWidget extends StatelessWidget {
  const TotalItemsWidget({
    super.key,
    required this.totalItems,
    required this.onPressed,
    required this.subtotal,
    required this.totalDiscount,
    required this.totalAmount,
  });
  final int totalItems;
  final double subtotal, totalDiscount, totalAmount;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Clear Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
          Text('Total Discount: \$${totalDiscount.toStringAsFixed(2)}'),
          const Divider(),
          Text(
            'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
