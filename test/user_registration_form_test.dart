import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('Invalid email and weak password show errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: UserRegistrationForm()));

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'a@');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      '123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      '321',
    );

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password is too weak'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Invalid email and weak password show errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.enterText(find.byType(TextFormField).at(1), 'a@'); // Email
    await tester.enterText(find.byType(TextFormField).at(2), '123'); // Password
    await tester.enterText(
      find.byType(TextFormField).at(3),
      '123',
    ); // Confirm Password

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password is too weak'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Valid inputs submit successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'John Doe',
    ); // Name
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'john@example.com',
    ); // Email
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Abc@1234',
    ); // Password
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'Abc@1234',
    ); // Confirm Password

    await tester.tap(find.text('Register'));
    await tester.pump(); // Initial UI rebuild
    await tester.pump(const Duration(seconds: 2)); // Simulate API delay

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
