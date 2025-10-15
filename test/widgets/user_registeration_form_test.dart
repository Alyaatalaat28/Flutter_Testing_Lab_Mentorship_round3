import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets("Should submit form when all fields are valid", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );
    expect(find.byType(UserRegistrationForm), findsOneWidget);
    await tester.enterText(find.byKey(const Key('nameField')), 'J');
    await tester.enterText(find.byKey(const Key('emailField')), 'wrong@');
    await tester.enterText(find.byKey(const Key('passwordField')), 'weak');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'weakk',
    );

    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pumpAndSettle();
    // Verify that the form is not submitted
    expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password is too weak'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(find.text('Registration successful!'), findsNothing);

    // Verify that the form is submitted successfully
    await tester.enterText(find.byKey(const Key('nameField')), 'John Doe');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'Test123!');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'Test123!',
    );

    await tester.tap(find.byKey(const Key('registerButton')));

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Registration successful!'), findsOneWidget);
  });

  testWidgets(
    "Should show errors for all empty fields and not show success message",
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.byType(UserRegistrationForm), findsOneWidget);

      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);

      expect(find.text('Registration successful!'), findsNothing);
    },
  );
}
