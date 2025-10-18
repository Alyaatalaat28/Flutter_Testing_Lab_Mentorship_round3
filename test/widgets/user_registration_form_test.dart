import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('UserRegistrationForm validation and submission test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UserRegistrationForm(),
        ),
      ),
    );

    // ✅ Verify all fields exist
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Register'), findsOneWidget);

    // Tap Register without entering anything
    await tester.tap(find.text('Register'));
    await tester.pump();

    // ✅ Verify validation messages appear
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);

    // ✅ Enter invalid email and weak password
    await tester.enterText(find.byType(TextFormField).at(0), 'Mo');
    await tester.enterText(find.byType(TextFormField).at(1), 'invalid_email');
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.enterText(find.byType(TextFormField).at(3), '123');

    await tester.tap(find.text('Register'));
    await tester.pump();

    // Check email & password error messages
    expect(find.text('Name must be at least 2 characters'), findsNothing);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password is too weak'), findsOneWidget);

    // ✅ Enter valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'Mohamed Emad');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'Password@123');
    await tester.enterText(find.byType(TextFormField).at(3), 'Password@123');

    await tester.tap(find.text('Register'));
    await tester.pump();

    // ✅ CircularProgressIndicator should appear
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the simulated API call
    await tester.pump(const Duration(seconds: 2));

    // ✅ Check for success message
    expect(find.text('Registration successful!'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
