import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/validator.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('test validation logic', () {
    test('should return true if email is valid', () {
      Validator validator = Validator();
      final result1 = validator.isValidEmail('G6A7o@example');
      expect(result1, equals(false));
      final result2 = validator.isValidEmail('G6A7oexample.com');
      expect(result2, isNot(true));
      final result3 = validator.isValidEmail('G6A7o@example.com');
      expect(result3, equals(true));
    });
  });
  test('should return true if password is valid', () {
    Validator validator = Validator();
    final result1 = validator.isValidPassword('password');
    expect(result1, equals(false));
    final result2 = validator.isValidPassword('123');
    expect(result2, equals(false));
    final result3 = validator.isValidPassword('Password123');
    expect(result3, equals(true));
  });

  group('UserRegistrationForm - UI Elements', () {
    testWidgets('should display all form fields on screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);

      expect(
        find.text('At least 8 characters with numbers and symbols'),
        findsOneWidget,
      );

      expect(find.byType(TextFormField), findsNWidgets(4));

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should find all fields by their keys', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.byKey(const ValueKey('fullName')), findsOneWidget);
      expect(find.byKey(const ValueKey('email')), findsOneWidget);
      expect(find.byKey(const ValueKey('password')), findsOneWidget);
    });
  });

  group('UserRegistrationForm - Validation', () {
    testWidgets('should show all validation errors when form is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('should show error for short name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byKey(const ValueKey('fullName')), 'A');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('should show error for invalid email format', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'invalidemail',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for email without @', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'testexample.com',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for email without domain', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byKey(const ValueKey('email')), 'test@');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for weak password', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'password123',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byKey(const ValueKey('password')), 'Pass1');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error for password without numbers', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'Password',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password456',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });

  group('UserRegistrationForm - Success State', () {
    testWidgets('should show success message after registration', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('fullName')),
        'John Doe',
      );
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'john@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Registration successful!'), findsOneWidget);
    });

    testWidgets('success message should be green', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('fullName')),
        'John Doe',
      );
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'john@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      final Text successText = tester.widget(
        find.text('Registration successful!'),
      );
      expect(successText.style?.color, Colors.green);
      expect(successText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('success message should be centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byKey(const ValueKey('fullName')),
        'John Doe',
      );
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'john@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      final Text successText = tester.widget(
        find.text('Registration successful!'),
      );
      expect(successText.textAlign, TextAlign.center);
    });
  });

  group('UserRegistrationForm - Integration Tests', () {
    testWidgets('complete registration flow from start to finish', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Registration successful!'), findsNothing);

      await tester.enterText(
        find.byKey(const ValueKey('fullName')),
        'Jane Smith',
      );

      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'jane.smith@example.com',
      );

      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'SecurePass123',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'SecurePass123',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Register'), findsNothing);

      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Registration successful!'), findsOneWidget);

      final Text successMessage = tester.widget(
        find.text('Registration successful!'),
      );
      expect(successMessage.style?.color, Colors.green);
      expect(successMessage.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should handle validation errors then success', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('fullName')),
        'Test User',
      );
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'TestPass123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'TestPass123',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your full name'), findsNothing);
      expect(find.text('Please enter your email'), findsNothing);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });

  group('UserRegistrationForm - Visual Tests', () {
    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.byType(Form), findsOneWidget);

      expect(find.byType(Column), findsWidgets);

      expect(find.byType(Padding), findsWidgets);

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('fields should have proper spacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

      expect(
        sizedBoxes.any((box) => box.height == 16 || box.height == 24),
        true,
      );
    });
  });
}
