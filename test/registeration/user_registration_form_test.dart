import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('shows validation errors for empty fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    // Tap the register button without entering data
    final Finder registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('shows email and password specific validation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.enterText(find.byType(TextFormField).at(1), 'a@'); // email
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'weak',
    ); // password
    await tester.enterText(find.byType(TextFormField).at(3), 'weak'); // confirm

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(
      find.textContaining('Password must be at least 8 characters'),
      findsOneWidget,
    );
  });

  testWidgets('accepts valid form and shows success message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Str0ng!Pass');
    await tester.enterText(find.byType(TextFormField).at(3), 'Str0ng!Pass');

    await tester.tap(find.text('Register'));
    // initial pump to start async work
    await tester.pump();
    // allow simulated API delay
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
