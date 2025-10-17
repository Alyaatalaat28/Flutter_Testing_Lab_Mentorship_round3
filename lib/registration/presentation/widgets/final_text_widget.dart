
import 'package:flutter/material.dart';

enum TextType { success, failure }

class FinalTextWidget extends StatelessWidget {
  const FinalTextWidget({
    super.key,
    required this.message,
    this.type = TextType.success,
  });
  final String message;
  final TextType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        message,
        style: TextStyle(
          color: type == TextType.success ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
