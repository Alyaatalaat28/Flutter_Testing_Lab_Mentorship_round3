


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('Unit Tests for validation logic', () {
    test('isValidEmail returns true for valid emails', () {
      expect(UserRegistrationForm.isValidEmail('test@test.com'), isTrue);
      expect(UserRegistrationForm.isValidEmail('noha.ahmed@domain.org'), isTrue);
    });

    test('isValidEmail returns false for invalid emails', () {
      expect(UserRegistrationForm.isValidEmail('test@test'), isFalse);
      expect(UserRegistrationForm.isValidEmail('test.com'), isFalse);
      expect(UserRegistrationForm.isValidEmail('@test.com'), isFalse);
    });

    test('isValidPassword returns true for strong passwords', () {
      expect(UserRegistrationForm.isValidPassword('Password123!'), isTrue);
      expect(UserRegistrationForm.isValidPassword('A1@aaaaa'), isTrue);
    });

    test('isValidPassword returns false for weak passwords', () {
      expect(UserRegistrationForm.isValidPassword('password'), isFalse);
      expect(UserRegistrationForm.isValidPassword('Password'), isFalse);
      (UserRegistrationForm.isValidPassword('Password123'), isFalse);
    });
  });


  // Widget tests
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('Should display all input fields and button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: UserRegistrationForm()),
      ));

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Shows validation errors when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: UserRegistrationForm()),
      ));

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Shows success message when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: UserRegistrationForm()),
      ));

      await tester.enterText(find.widgetWithText(TextFormField, 'Full Name'), 'Noha Ahmed');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'Pass123!');
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'Pass123!');

      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });
}