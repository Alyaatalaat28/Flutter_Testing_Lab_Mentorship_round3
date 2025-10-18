import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  testWidgets('ShoppingCart Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(width: 800, height: 1200, child: ShoppingCart()),
      ),
    );

    expect(find.text('Cart is empty'), findsOneWidget);

    await tester.tap(find.text('Add iPhone'));
    await tester.pump();
    expect(find.text('Apple iPhone'), findsOneWidget);
    expect(find.text('Total Items: 1'), findsOneWidget);
    expect(find.text('Subtotal: \$999.99'), findsOneWidget);
    await tester.tap(find.text('Add iPhone'));
    await tester.pump();
    expect(find.text('Total Items: 2'), findsOneWidget);

    await tester.tap(find.text('Add Galaxy'));
    await tester.pump();

    expect(find.text('Samsung Galaxy'), findsOneWidget);
    expect(find.text('Total Items: 3'), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add).first);
    await tester.pump();

    expect(find.text('Total Items: 4'), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.remove).first);
    await tester.pump();

    expect(find.text('Total Items: 3'), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pump();

    expect(find.text('Apple iPhone'), findsNothing);

    await tester.tap(find.text('Clear Cart'));
    await tester.pump();

    expect(find.text('Cart is empty'), findsOneWidget);
    expect(find.text('Total Items: 0'), findsOneWidget);
  });
}
