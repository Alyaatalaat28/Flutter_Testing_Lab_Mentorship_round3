import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    // Helper to pump the widget
    Future<void> pumpForm(
      WidgetTester tester, {
      Future<void> Function()? onSubmit,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserRegistrationForm(onSubmit: onSubmit)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('displays all form fields and submit button', (tester) async {
      await pumpForm(tester);

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('shows validation errors for empty fields', (tester) async {
      await pumpForm(tester);

      // Leave all fields empty and tap register
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
      expect(
        find.text('Please correct the errors in the form.'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation errors for invalid input', (tester) async {
      await pumpForm(tester);

      // Invalid name
      await tester.enterText(find.byType(TextFormField).at(0), 'John123');
      await tester.pumpAndSettle();
      expect(
        find.text('Name should contain only letters and spaces'),
        findsOneWidget,
      );

      // Invalid email
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '123test@example.com',
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Invalid email format (only letters allowed in local part)'),
        findsOneWidget,
      );

      // Weak password
      await tester.enterText(find.byType(TextFormField).at(2), 'weak');
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.',
        ),
        findsOneWidget,
      );

      // Password mismatch
      await tester.enterText(find.byType(TextFormField).at(2), 'Passw0rd#');
      await tester.enterText(find.byType(TextFormField).at(3), 'different');
      await tester.pumpAndSettle();
      expect(find.text('Passwords do not match'), findsOneWidget);

      // Tap register
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      expect(
        find.text('Please correct the errors in the form.'),
        findsOneWidget,
      );
    });

    testWidgets('successful submission shows success message', (tester) async {
      await pumpForm(
        tester,
        onSubmit: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Passw0rd#');
      await tester.enterText(find.byType(TextFormField).at(3), 'Passw0rd#');

      await tester.tap(find.text('Register'));
      await tester.pump(); // Start async operation

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Registration successful!'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('submit button is disabled while loading', (tester) async {
      await pumpForm(
        tester,
        onSubmit: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Passw0rd#');
      await tester.enterText(find.byType(TextFormField).at(3), 'Passw0rd#');

      await tester.tap(find.text('Register'));
      await tester.pump(); // Start async

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull); // Disabled
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message on failed submission', (tester) async {
      await pumpForm(
        tester,
        onSubmit: () async {
          await Future.delayed(const Duration(seconds: 2));
          throw Exception('API error');
        },
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Passw0rd#');
      await tester.enterText(find.byType(TextFormField).at(3), 'Passw0rd#');

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(
        find.text('Registration failed: Exception: API error'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
