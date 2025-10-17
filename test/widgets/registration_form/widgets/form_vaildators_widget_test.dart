
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/registration_form/user_registration_form.dart';
import 'package:flutter_testing_lab/widgets/registration_form/widgets/register_btn.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS - دوال مساعدة لتسهيل الاختبارات
  // ═══════════════════════════════════════════════════════════════════════
  
  /// دالة لعرض الـ Widget في بيئة الاختبار
  /// السبب: محتاجين MaterialApp عشان الـ Theme والـ MediaQuery
  Widget createTestWidget() {
    return const MaterialApp(
      home: Scaffold(
        body: UserRegistrationForm(),
      ),
    );
  }

  /// دالة للبحث عن TextField بناءً على الـ label
  /// السبب: أسهل من كتابة find.widgetWithText في كل مرة
  Finder findFieldByLabel(String label) {
    return find.widgetWithText(TextFormField, label);
  }

  /// دالة لملء جميع الحقول ببيانات صحيحة
  /// السبب: نستخدمها في اختبارات كتير، فأحسن نعملها دالة
  Future<void> fillValidForm(WidgetTester tester) async {
    // إدخال اسم صحيح
    await tester.enterText(
      findFieldByLabel('Full Name'), 
      'Ahmed Mohamed',
    );
    
    // إدخال إيميل صحيح
    await tester.enterText(
      findFieldByLabel('Email'), 
      'ahmed@example.com',
    );
    
    // إدخال كلمة مرور صحيحة
    await tester.enterText(
      findFieldByLabel('Password'), 
      'Password@123',
    );
    
    // تأكيد كلمة المرور
    await tester.enterText(
      findFieldByLabel('Confirm Password'), 
      'Password@123',
    );
    
    // إعادة بناء الـ UI لتطبيق التغييرات
    await tester.pump();
  }

  /// دالة لإيجاد زر التسجيل
  Finder findRegisterButton() {
    return find.byType(RegisterBtn);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // المجموعة الأولى: اختبار عرض الـ Form الأولي
  // ═══════════════════════════════════════════════════════════════════════
  
  group('UserRegistrationForm - Initial Display -', () {
    
    testWidgets('should display all form fields', (WidgetTester tester) async {
      // ARRANGE: عرض الـ widget
      await tester.pumpWidget(createTestWidget());
      
      // ASSERT: التحقق من وجود جميع الحقول
      // السبب: نتأكد إن الـ Form بيعرض كل العناصر المطلوبة
      
      expect(findFieldByLabel('Full Name'), findsOneWidget);
      expect(findFieldByLabel('Email'), findsOneWidget);
      expect(findFieldByLabel('Password'), findsOneWidget);
      expect(findFieldByLabel('Confirm Password'), findsOneWidget);
    });

    testWidgets('should display Register button', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ASSERT: التحقق من وجود الزر
      expect(findRegisterButton(), findsOneWidget);
      
      // التحقق من نص الزر
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should display password helper text', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ASSERT: التحقق من وجود نص المساعدة لكلمة المرور
      // السبب: نتأكد إن المستخدم شايف المتطلبات
      expect(
        find.text('At least 8 chars, uppercase, lowercase, number, symbol'),
        findsOneWidget,
      );
    });

    testWidgets('should not display any validation errors initially', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ASSERT: لا يجب أن تظهر أي رسائل خطأ في البداية
      // السبب: الـ validation يحصل بعد التفاعل فقط
      expect(find.text('Please enter your full name'), findsNothing);
      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter a password'), findsNothing);
    });

    testWidgets('should not display success message initially', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ASSERT
      expect(find.text('Registration successful!'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // المجموعة الثانية: اختبار Name Validation في الـ UI
  // ═══════════════════════════════════════════════════════════════════════
  
  group('UserRegistrationForm - Name Field Validation -', () {
    
    testWidgets('should show error when name is empty and form is submitted', 
        (WidgetTester tester) async {
      // ARRANGE: عرض الـ Form
      await tester.pumpWidget(createTestWidget());
      
      // ACT: نضغط على زر التسجيل مباشرة بدون ملء الحقول
      await tester.tap(findRegisterButton());
      await tester.pump(); // إعادة بناء الـ UI
      
      // ASSERT: يجب أن تظهر رسالة الخطأ
      // السبب: الـ Form يعمل validate عند الضغط على الزر
      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('should show error for name with less than 2 characters', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT: إدخال حرف واحد فقط
      await tester.enterText(findFieldByLabel('Full Name'), 'A');
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(
        find.text('Name must be at least 2 characters'), 
        findsOneWidget,
      );
    });

    testWidgets('should accept valid name with 2 characters', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT: إدخال حرفين (الحد الأدنى)
      await tester.enterText(findFieldByLabel('Full Name'), 'Jo');
      
      // ملء باقي الحقول بشكل صحيح
      await tester.enterText(findFieldByLabel('Email'), 'test@example.com');
      await tester.enterText(findFieldByLabel('Password'), 'Password@123');
      await tester.enterText(findFieldByLabel('Confirm Password'), 'Password@123');
      
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT: لا يجب أن تظهر رسالة خطأ للاسم
      expect(find.text('Name must be at least 2 characters'), findsNothing);
      expect(find.text('Please enter your full name'), findsNothing);
    });

    testWidgets('should accept long names', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT: اسم طويل
      await tester.enterText(
        findFieldByLabel('Full Name'), 
        'Ahmed Mohamed Ali Hassan',
      );
      await fillValidForm(tester);
      
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT: لا أخطاء في الاسم
      expect(find.text('Please enter your full name'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // المجموعة الثالثة: اختبار Email Validation في الـ UI
  // ═══════════════════════════════════════════════════════════════════════
  
  group('UserRegistrationForm - Email Field Validation -', () {
    
    testWidgets('should show error when email is empty', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show error when email lacks @ symbol', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT: إدخال إيميل بدون @
      await tester.enterText(
        findFieldByLabel('Email'), 
        'invalidemail.com',
      );
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should accept valid email format', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT: إدخال إيميل صحيح
      await tester.enterText(
        findFieldByLabel('Email'), 
        'user@example.com',
      );
      
      // ملء باقي الحقول
      await tester.enterText(findFieldByLabel('Full Name'), 'Ahmed Ali');
      await tester.enterText(findFieldByLabel('Password'), 'Password@123');
      await tester.enterText(findFieldByLabel('Confirm Password'), 'Password@123');
      
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT: لا أخطاء في الإيميل
      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter a valid email'), findsNothing);
    });

    testWidgets('should accept email with subdomain', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT
      await tester.enterText(
        findFieldByLabel('Email'), 
        'user@mail.example.com',
      );
      await fillValidForm(tester);
      
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(find.text('Please enter a valid email'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // المجموعة الرابعة: اختبار Password Validation في الـ UI
  // ═══════════════════════════════════════════════════════════════════════
  
  group('UserRegistrationForm - Password Field Validation -', () {
    
    testWidgets('should show error when password is empty', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('should show error when password lacks lowercase', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT: كلمة مرور بدون lowercase
      await tester.enterText(
        findFieldByLabel('Password'), 
        'PASSWORD@123',
      );
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(
        find.text('Password must contain lowercase letter'), 
        findsOneWidget,
      );
    });

    testWidgets('should show error when password lacks uppercase', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT
      await tester.enterText(
        findFieldByLabel('Password'), 
        'password@123',
      );
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(
        find.text('Password must contain uppercase letter'), 
        findsOneWidget,
      );
    });

    testWidgets('should show error when password lacks number', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT
      await tester.enterText(
        findFieldByLabel('Password'), 
        'Password@abc',
      );
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(
        find.text('Password must contain a number'), 
        findsOneWidget,
      );
    });

    testWidgets('should show error when password lacks special character', 
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(createTestWidget());
      
      // ACT
      await tester.enterText(
        findFieldByLabel('Password'), 
        'Password123',
      );
      await tester.tap(findRegisterButton());
      await tester.pump();
      
      // ASSERT
      expect(
        find.text('Password must contain special character'), 
        findsOneWidget,
      );
    });

  });
}