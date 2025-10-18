import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm - Unit Tests', () {
    late dynamic formState;

    setUp(() {
      final widget = const UserRegistrationForm();
      formState = widget.createState();
    });

    group('Email Validation', () {
      test('should accept valid emails', () {
        expect(formState.isValidEmail('test@example.com'), true);
        expect(formState.isValidEmail('user.name@domain.co.uk'), true);
      });

      test('should reject invalid emails', () {
        expect(formState.isValidEmail('a@'), false);
        expect(formState.isValidEmail('@b'), false);
        expect(formState.isValidEmail('invalidemail.com'), false);
        expect(formState.isValidEmail(''), false);
      });
    });

    group('Password Validation', () {
      test('should accept strong passwords', () {
        expect(formState.isValidPassword('Password123!'), true);
        expect(formState.isValidPassword('Str0ng@Pass'), true);
      });

      test('should reject weak passwords', () {
        expect(formState.isValidPassword('weak'), false); // Too short
        expect(formState.isValidPassword('Password'), false); // No number or special char
        expect(formState.isValidPassword('Pass123'), false); // No special char
        expect(formState.isValidPassword('Pass!@#'), false); // No number
        expect(formState.isValidPassword('12345678!'), false); // No letter
        expect(formState.isValidPassword(''), false); // Empty
      });
    });
  });

  group('UserRegistrationForm - Widget Tests', () {
    testWidgets('should render all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('should reject invalid email format',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'a@');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should reject weak passwords', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'weak');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should reject mismatched passwords',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'Password123!');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          'DifferentPass123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should show loading state and success message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'Password123!');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          'Password123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('Registration successful!'), findsOneWidget);
    });

    testWidgets('should not submit form with invalid data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'invalidemail');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'Password123!');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          'Password123!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Registration successful!'), findsNothing);
    });
  });
}
