import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/shopping_cubit.dart'; 
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/shopping_cart.dart';

void main() {
  group('🧪 ShoppingCart Widget Tests', () {
    late ShoppingCubit cubit;

    setUp(() {
      cubit = ShoppingCubit();
    });

    Widget makeTestableWidget(Widget child) {
      return MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(body: child),
        ),
      );
    }

    testWidgets('shows empty cart text initially', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const ShoppingCart()));

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('adds item when pressing "Add iPhone"', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const ShoppingCart()));

      // اضغط على زر إضافة iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // المفروض يختفي "Cart is empty"
      expect(find.text('Cart is empty'), findsNothing);

      // المنتج يظهر في اللستة
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.textContaining('Price:'), findsOneWidget);

      // الـTotal Items يتحدث
      expect(find.textContaining('Total Items:'), findsOneWidget);
    });

    testWidgets('clears cart when pressing "Clear Cart"', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const ShoppingCart()));

      // أضف منتج
      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // اضغط Clear Cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      // المفروض تظهر رسالة Cart is empty تاني
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('updates quantity when pressing + and - buttons', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const ShoppingCart()));

      await tester.tap(find.text('Add iPhone'));
      await tester.pumpAndSettle();

      // اضغط على زر +
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // المفروض الكمية تزيد لـ 2
      expect(find.text('2'), findsOneWidget);

      // اضغط على زر -
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // المفروض الكمية ترجع لـ 1
      expect(find.text('1'), findsOneWidget);
    });
  });
}
