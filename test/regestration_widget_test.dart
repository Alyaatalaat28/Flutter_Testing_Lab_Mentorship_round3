import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    // Helper function to reduce code duplication
    Future<void> pumpForm(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );
    }

    // Helper function to submit form
    Future<void> submitForm(WidgetTester tester) async {
      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
    }

    testWidgets('should render all form fields', (tester) async {
      // ARRANGE
      await pumpForm(tester);

      // ASSERT
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (
      tester,
    ) async {
      // ARRANGE
      await pumpForm(tester);

      // ACT
      await submitForm(tester);

      // ASSERT
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
      expect(
        find.text('Please fix the errors in red before submitting.'),
        findsOneWidget,
      );
    });

    testWidgets('should show error for invalid email', (tester) async {
      // ARRANGE
      await pumpForm(tester);

      // ACT
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalidemail',
      );
      await submitForm(tester);

      // ASSERT
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for weak password', (tester) async {
      // ARRANGE
      await pumpForm(tester);

      // ACT
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'weak',
      );
      await submitForm(tester);

      // ASSERT
      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      // ARRANGE
      await pumpForm(tester);

      // ACT
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'different123',
      );
      await submitForm(tester);

      // ASSERT
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should show success message for valid form', (tester) async {
      // ARRANGE
      await pumpForm(tester);

      // ACT
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'password123',
      );
      await submitForm(tester);

      // ASSERT
      expect(find.text('Registration successful!'), findsOneWidget);
    });

  });
}
