import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  runApp(const FlutterTestingLabApp());
}

class FlutterTestingLabApp extends StatelessWidget {
  const FlutterTestingLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Testing Lab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(body: const ShoppingCart()),
      debugShowCheckedModeBanner: false,
    );
  }
}
