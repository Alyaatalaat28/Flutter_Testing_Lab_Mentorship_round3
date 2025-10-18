import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/feature/shop_feature/shopping_cart.dart';

void main() {
  group('ShoppingCart Widget Tests', () {
    testWidgets('should display empty cart message initially',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          expect(find.text('Cart is empty'), findsOneWidget);
          expect(find.text('Total Items: 0'), findsOneWidget);
        });

    testWidgets('should display add item buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      expect(find.text('Add iPhone'), findsOneWidget);
      expect(find.text('Add Galaxy'), findsOneWidget);
      expect(find.text('Add iPad'), findsOneWidget);
      expect(find.text('Clear Cart'), findsOneWidget);
    });

    testWidgets('should add iPhone to cart when button is pressed',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          expect(find.text('Apple iPhone'), findsOneWidget);
          expect(find.text('Total Items: 1'), findsOneWidget);
          expect(find.text('Price: \$999.99 each'), findsOneWidget);
          expect(find.text('Discount: 10%'), findsOneWidget);
        });

    testWidgets('should add Galaxy to cart when button is pressed',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add Galaxy'));
          await tester.pump();

          expect(find.text('Samsung Galaxy'), findsOneWidget);
          expect(find.text('Total Items: 1'), findsOneWidget);
          expect(find.text('Discount: 15%'), findsOneWidget);
        });

    testWidgets('should add iPad to cart without discount',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPad'));
          await tester.pump();

          expect(find.text('iPad Pro'), findsOneWidget);
          expect(find.text('Total Items: 1'), findsOneWidget);
          // Check that discount percentage is NOT shown in item details
          // The "Total Discount: $0.00" will appear in summary, but not "Discount: X%" in item
          expect(find.text('Discount: 0%'), findsNothing);
        });

    testWidgets('should add multiple items to cart',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pump();

          await tester.tap(find.text('Add iPad'));
          await tester.pump();

          expect(find.text('Total Items: 3'), findsOneWidget);
          expect(find.text('Apple iPhone'), findsOneWidget);
          expect(find.text('Samsung Galaxy'), findsOneWidget);
          expect(find.text('iPad Pro'), findsOneWidget);
        });

    testWidgets('should increment quantity when adding same item',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          expect(find.text('Total Items: 2'), findsOneWidget);
          expect(find.text('2'), findsOneWidget);
        });

    testWidgets('should increase quantity when plus button is pressed',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.byIcon(Icons.add));
          await tester.pump();

          expect(find.text('Total Items: 2'), findsOneWidget);
          expect(find.text('2'), findsOneWidget);
        });

    testWidgets('should decrease quantity when minus button is pressed',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.byIcon(Icons.remove));
          await tester.pump();

          expect(find.text('Total Items: 1'), findsOneWidget);
          expect(find.text('1'), findsOneWidget);
        });

    testWidgets('should remove item when quantity reaches zero',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.byIcon(Icons.remove));
          await tester.pump();

          expect(find.text('Cart is empty'), findsOneWidget);
          expect(find.text('Total Items: 0'), findsOneWidget);
        });

    testWidgets('should remove item when delete button is pressed',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.byIcon(Icons.delete));
          await tester.pump();

          expect(find.text('Cart is empty'), findsOneWidget);
          expect(find.text('Total Items: 0'), findsOneWidget);
        });

    testWidgets('should clear all items when clear cart button is pressed',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pump();

          await tester.tap(find.text('Add iPad'));
          await tester.pump();

          await tester.tap(find.text('Clear Cart'));
          await tester.pump();

          expect(find.text('Cart is empty'), findsOneWidget);
          expect(find.text('Total Items: 0'), findsOneWidget);
        });

    testWidgets('should display correct subtotal', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Subtotal: \$999.99'), findsOneWidget);
    });

    testWidgets('should display correct total discount',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          // iPhone has 10% discount: 999.99 * 0.1 = 99.999
          expect(find.textContaining('Total Discount: \$100.00'), findsOneWidget);
        });

    testWidgets('should display correct total amount',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          // 999.99 - 99.999 = 899.991
          expect(find.textContaining('Total Amount: \$899.99'), findsOneWidget);
        });

    testWidgets('should display item total correctly',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.byIcon(Icons.add));
          await tester.pump();

          // 999.99 * 2 = 1999.98
          expect(find.text('Item Total: \$1999.98'), findsOneWidget);
        });

    testWidgets('should handle multiple items with different discounts',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pump();

          expect(find.text('Total Items: 2'), findsOneWidget);
          expect(find.text('Discount: 10%'), findsOneWidget);
          expect(find.text('Discount: 15%'), findsOneWidget);
        });

    testWidgets('should scroll when content overflows',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          // Add many items
          for (int i = 0; i < 10; i++) {
            await tester.tap(find.text('Add iPhone'));
            await tester.pump();
          }

          expect(find.byType(SingleChildScrollView), findsOneWidget);
        });

    testWidgets('should display ListTile for each cart item',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          await tester.tap(find.text('Add Galaxy'));
          await tester.pump();

          expect(find.byType(ListTile), findsNWidgets(2));
        });

    testWidgets('should display Card for each cart item',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ShoppingCart(),
              ),
            ),
          );

          await tester.tap(find.text('Add iPhone'));
          await tester.pump();

          expect(find.byType(Card), findsOneWidget);
        });
  });
}