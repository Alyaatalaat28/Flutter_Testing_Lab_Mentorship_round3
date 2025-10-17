import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('Form fields are rendered correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Empty form submission shows validation errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Invalid email shows validation error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'a@');
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Valid email does not show validation error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123!',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsNothing);
    });

    testWidgets('Weak password shows validation error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'weak',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Password must be at least 8 characters with uppercase, lowercase, numbers and symbols',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Password without special characters shows validation error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Password must be at least 8 characters with uppercase, lowercase, numbers and symbols',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Mismatched passwords show validation error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'DifferentPass123!',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Matching strong passwords do not show error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123!',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsNothing);
    });

    testWidgets('Short name shows validation error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'A',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('Valid form submission shows loading state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123!',
      );

      await tester.tap(find.text('Register'));
      await tester.pump(); // Start the loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the async operation to complete
      await tester.pumpAndSettle();
    });

    testWidgets('Valid form submission shows success message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123!',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Registration successful!'), findsOneWidget);
    });

    testWidgets('Invalid form submission shows error message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please fix the errors above'), findsOneWidget);
    });

    testWidgets('Password fields are obscured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Find the TextField widgets inside the TextFormFields
      final passwordFields = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(TextField),
      );
      final confirmPasswordFields = find.descendant(
        of: find.widgetWithText(TextFormField, 'Confirm Password'),
        matching: find.byType(TextField),
      );

      final passwordTextField = tester.widget<TextField>(passwordFields);
      final confirmPasswordTextField = tester.widget<TextField>(
        confirmPasswordFields,
      );

      expect(passwordTextField.obscureText, true);
      expect(confirmPasswordTextField.obscureText, true);
    });

    testWidgets('Email field has correct keyboard type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Find the TextField widget inside the TextFormField
      final emailFields = find.descendant(
        of: find.widgetWithText(TextFormField, 'Email'),
        matching: find.byType(TextField),
      );

      final emailTextField = tester.widget<TextField>(emailFields);

      expect(emailTextField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('Button is disabled during loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'Password123!',
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Register'),
      );

      expect(button.onPressed, null);
    });
  });
}
