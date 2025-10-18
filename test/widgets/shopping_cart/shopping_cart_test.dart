import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart/shopping_cart.dart';
// import 'package:your_app/shopping_cart.dart'; // استبدل بالمسار الصحيح

// ==================== شرح TestWidgets ====================
// دي بتستخدم علشان نختبر الويدجت بتاعتنا في بيئة تيست
// بتسمحلنا نعمل pump للويدجت ونتفاعل معاها

void main() {
  // ==================== المجموعة الأولى: اختبار إضافة العناصر ====================
  group('Add Items', () {
    
    // ==================== اختبار 1: إضافة عنصر واحد ====================
    testWidgets('يجب إضافة عنصر واحد للعربة بنجاح', (WidgetTester tester) async {
      // الخطوة 1: نبني الويدجت في بيئة التيست
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // الخطوة 2: نتأكد إن العربة فاضية في البداية
      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);

      // الخطوة 3: ندوس على زرار إضافة iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump(); // نعمل refresh للويدجت

      // الخطوة 4: نتحقق إن العنصر اتضاف
      expect(find.text('Cart is empty'), findsNothing); // العربة مش فاضية دلوقتي
      expect(find.text('Total Items: 1'), findsOneWidget); // عندنا عنصر واحد
      expect(find.text('Apple iPhone'), findsOneWidget); // اسم المنتج ظهر
    });

    // ==================== اختبار 2: إضافة عناصر متعددة مختلفة ====================
    testWidgets('يجب إضافة عناصر متعددة مختلفة', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نضيف Galaxy
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      // نضيف iPad
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      // نتحقق إن كل المنتجات موجودة
      expect(find.text('Total Items: 3'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Samsung Galaxy'), findsOneWidget);
      expect(find.text('iPad Pro'), findsOneWidget);
    });

    // ==================== اختبار 3: زيادة الكمية لنفس المنتج ====================
    testWidgets('يجب زيادة الكمية عند إضافة نفس المنتج', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone أول مرة
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نضيف iPhone تاني مرة باستخدام زرار "Add iPhone Again"
      await tester.tap(find.text('Add iPhone Again'));
      await tester.pump();

      // نتحقق إن الكمية زادت
      expect(find.text('Total Items: 2'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // الكمية في الكارد
    });
  });

  // ==================== المجموعة الثانية: اختبار حذف العناصر ====================
  group('Remove Items', () {
    
    // ==================== اختبار 4: حذف عنصر واحد ====================
    testWidgets('يجب حذف عنصر واحد من العربة', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نتأكد إن العنصر موجود
      expect(find.text('Apple iPhone'), findsOneWidget);

      // ندوس على زرار Delete
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // نتحقق إن العنصر اتحذف
      expect(find.text('Apple iPhone'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    // ==================== اختبار 5: تقليل الكمية ====================
    testWidgets('يجب تقليل الكمية عند الضغط على زرار ناقص', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نزود الكمية
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      
      expect(find.text('2'), findsOneWidget);

      // نقلل الكمية
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // نتحقق إن الكمية قلت
      expect(find.text('1'), findsOneWidget);
    });

    // ==================== اختبار 6: حذف العنصر لما الكمية توصل صفر ====================
    testWidgets('يجب حذف العنصر عند تقليل الكمية لصفر', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsOneWidget);

      // نضغط على ناقص علشان الكمية توصل صفر
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // العنصر المفروض يتحذف تلقائياً
      expect(find.text('Apple iPhone'), findsNothing);
      expect(find.text('Cart is empty'), findsOneWidget);
    });

    // ==================== اختبار 7: مسح العربة بالكامل ====================
    testWidgets('يجب مسح كل العناصر عند الضغط على Clear Cart', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف منتجات مختلفة
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();
      await tester.tap(find.text('Add iPad'));
      await tester.pump();

      expect(find.text('Total Items: 3'), findsOneWidget);

      // نضغط على Clear Cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      // نتحقق إن العربة فضت
      expect(find.text('Cart is empty'), find);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });
  });

  // ==================== المجموعة الثالثة: اختبار الحسابات ====================
  group('Price Calculations', () {
    
    // ==================== اختبار 8: حساب السعر الإجمالي بدون خصم ====================
    testWidgets('يجب حساب السعر الإجمالي بدون خصم بشكل صحيح', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone (999.99)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نتحقق من السعر الإجمالي قبل الخصم
      // iPhone سعره 999.99 مع خصم 10%
      expect(find.textContaining('Subtotal: \$999.99'), findsOneWidget);
    });

    // ==================== اختبار 9: حساب الخصم بشكل صحيح ====================
    testWidgets('يجب حساب الخصم بشكل صحيح', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone (999.99 مع خصم 10%)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // الخصم المتوقع = 999.99 * 0.1 = 99.999 ≈ 100.00
      expect(find.textContaining('Total Discount: \$100.00'), findsOneWidget);
      
      // نتحقق من السعر النهائي = 999.99 - 100.00 = 899.99
      expect(find.textContaining('Total Amount: \$899.99'), findsOneWidget);
    });

    // ==================== اختبار 10: حساب السعر مع منتجات متعددة وخصومات مختلفة ====================
    testWidgets('يجب حساب السعر مع منتجات متعددة وخصومات مختلفة', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone (999.99 - خصم 10%)
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نضيف Galaxy (899.99 - خصم 15%)
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      // الحسابات المتوقعة:
      // Subtotal = 999.99 + 899.99 = 1899.98
      expect(find.textContaining('Subtotal: \$1899.98'), findsOneWidget);

      // Total Discount = (999.99 * 0.1) + (899.99 * 0.15) = 99.999 + 135.00 = 235.00
      expect(find.textContaining('Total Discount: \$235.00'), findsOneWidget);

      // Total Amount = 1899.98 - 235.00 = 1664.98
      expect(find.textContaining('Total Amount: \$1664.98'), findsOneWidget);
    });

    // ==================== اختبار 11: حساب السعر مع كميات متعددة ====================
    testWidgets('يجب حساب السعر بشكل صحيح مع كميات متعددة', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف iPhone
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نزود الكمية
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // دلوقتي عندنا 2 iPhone
      // Subtotal = 999.99 * 2 = 1999.98
      expect(find.textContaining('Subtotal: \$1999.98'), findsOneWidget);

      // Total Discount = 999.99 * 0.1 * 2 = 199.998 ≈ 200.00
      expect(find.textContaining('Total Discount: \$200.00'), findsOneWidget);

      // Total Amount = 1999.98 - 200.00 = 1799.98
      expect(find.textContaining('Total Amount: \$1799.98'), findsOneWidget);
    });
  });


  // ==================== المجموعة الخامسة: اختبار الواجهة (UI Tests) ====================
  group('UI Elements)', () {
    
    // ==================== اختبار 19: وجود كل الأزرار ====================
    testWidgets('يجب عرض كل أزرار الإضافة', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نتحقق من وجود كل الأزرار
      expect(find.text('Add iPhone'), findsOneWidget);
      expect(find.text('Add Galaxy'), findsOneWidget);
      expect(find.text('Add iPad'), findsOneWidget);
      expect(find.text('Add iPhone Again'), findsOneWidget);
      expect(find.text('Clear Cart'), findsOneWidget);
    });

    // ==================== اختبار 20: عرض تفاصيل المنتج في الكارد ====================
    testWidgets('يجب عرض تفاصيل المنتج بالكامل', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف Galaxy
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      // نتحقق من كل التفاصيل
      expect(find.text('Samsung Galaxy'), findsOneWidget); // العنوان
      expect(find.textContaining('Price: \$899.99 each'), findsOneWidget); // السعر
      expect(find.textContaining('Discount: 15%'), findsOneWidget); // الخصم
      expect(find.textContaining('Item Total:'), findsOneWidget); // الإجمالي
    });

    // ==================== اختبار 21: وجود أيقونات التحكم ====================
    testWidgets('يجب عرض أيقونات التحكم في الكمية', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نضيف منتج
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // نتحقق من وجود الأيقونات
      expect(find.byIcon(Icons.add), findsOneWidget); // زرار الزيادة
      expect(find.byIcon(Icons.remove), findsOneWidget); // زرار التقليل
      expect(find.byIcon(Icons.delete), findsOneWidget); // زرار الحذف
    });

    // ==================== اختبار 22: لون زرار الحذف ====================
    testWidgets('يجب أن يكون زرار Clear Cart باللون الأحمر', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // نلاقي الزرار
      final clearButton = find.text('Clear Cart');
      expect(clearButton, findsOneWidget);

      // نتحقق من اللون
      final ElevatedButton button = tester.widget(find.ancestor(
        of: clearButton,
        matching: find.byType(ElevatedButton),
      ));
      
      expect(button.style?.backgroundColor?.resolve({}), Colors.red);
    });
  });
}
