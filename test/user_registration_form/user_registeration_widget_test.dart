import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart'; // غيّرها حسب مسار الملف

void main() {
  testWidgets('Shows validation errors when form is invalid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('Shows password mismatch error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('passwordField')), '12345678');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      '87654321',
    );

    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Successful registration shows success message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Mazen Anter');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'Pass@123');
    await tester.enterText(find.byType(TextFormField).at(3), 'Pass@123');

    await tester.tap(find.text('Register'));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
