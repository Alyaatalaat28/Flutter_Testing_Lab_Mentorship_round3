import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key, required this.currentIndex});
  final int currentIndex ;

  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                border: Border(
                  bottom: BorderSide(color: Colors.orange.shade300),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Current Widget: ${_getWidgetName(currentIndex)} - Contains bugs that need fixing!',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
  }
   String _getWidgetName(int index) {
    switch (index) {
      case 0:
        return 'User Registration Form';
      case 1:
        return 'Shopping Cart';
      case 2:
        return 'Weather Display';
      default:
        return 'Unknown Widget';
    }
  }
}
