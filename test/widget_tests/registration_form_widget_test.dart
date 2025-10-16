import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  Future<void> pumpRegistrationForm(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );
  }

  Future<void> enterText(WidgetTester tester, String label, String text) async {
    final inputFinder = find.byWidgetPredicate(
      (widget) =>
          widget is InputDecorator && widget.decoration.labelText == label,
      description: 'TextFormField with label: "$label"',
    );

    await tester.enterText(inputFinder, text);
  }

  group('UserRegistrationForm Widget Tests', () {
    testWidgets(
      'Submitting with empty fields shows all required validation errors',
      (tester) async {
        await pumpRegistrationForm(tester);

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Full name is required'), findsOneWidget);
        expect(find.text('Email is required'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);

        expect(
          find.text('Please correct the errors in the form.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Submitting with invalid data shows specific validation messages',
      (tester) async {
        await pumpRegistrationForm(tester);

        await enterText(tester, 'Full Name', '123InvalidName');
        await enterText(tester, 'Email', 'badformat');
        await enterText(tester, 'Password', 'tooWeak');
        await enterText(tester, 'Confirm Password', 'tooWeak');

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Name should contain only letters'), findsOneWidget);
        expect(find.text('Invalid email format'), findsOneWidget);
        expect(
          find.textContaining('Password must be at least 8 characters long'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Submitting with valid data shows loading indicator and success message',
      (tester) async {
        await pumpRegistrationForm(tester);

        await enterText(tester, 'Full Name', 'Alice Smith');
        await enterText(tester, 'Email', 'alice.smith@valid.net');
        await enterText(tester, 'Password', 'SecureP@ss1');
        await enterText(tester, 'Confirm Password', 'SecureP@ss1');

        await tester.tap(find.text('Register'));
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle(const Duration(seconds: 3));

        expect(find.text('Registration successful!'), findsOneWidget);
      },
    );

    testWidgets('Mismatched passwords show validation error', (tester) async {
      await pumpRegistrationForm(tester);

      await enterText(tester, 'Password', 'SecureP@ss1');
      await enterText(tester, 'Confirm Password', 'DifferentP@ss2');

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });
}
