import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  testWidgets('Shopping cart basic operations test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ShoppingCart()),
      ),
    );

    expect(find.text('Cart is empty'), findsOneWidget);

    await tester.tap(find.text('Add iPhone'));
    await tester.pump();

    expect(find.text('Apple iPhone'), findsOneWidget);
    expect(find.text('Cart is empty'), findsNothing);

    await tester.tap(find.text('Add Galaxy'));
    await tester.pump();

    expect(find.text('Samsung Galaxy'), findsOneWidget);

    expect(find.textContaining('Total Items: 2'), findsOneWidget);

    final addButtons = find.byIcon(Icons.add);
    await tester.tap(addButtons.first);
    await tester.pump();

    expect(find.text('2'), findsOneWidget);

    final removeButtons = find.byIcon(Icons.remove);
    await tester.tap(removeButtons.first);
    await tester.pump();

    expect(find.text('1'), findsWidgets);

    final deleteButtons = find.byIcon(Icons.delete);
    await tester.tap(deleteButtons.last);
    await tester.pump();

    expect(find.text('Samsung Galaxy'), findsNothing);

    await tester.tap(find.text('Clear Cart'));
    await tester.pump();

    expect(find.text('Cart is empty'), findsOneWidget);
  });
}
