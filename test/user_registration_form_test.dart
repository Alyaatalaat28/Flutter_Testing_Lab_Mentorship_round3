import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('Shows validation messages for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: UserRegistrationForm()));

    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('Shows success message when form is valid', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: UserRegistrationForm()));

    await tester.enterText(find.byKey(const Key('nameField')), 'Nadia Khaled');
    await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'Abc@1234');
    await tester.enterText(find.byKey(const Key('confirmPasswordField')), 'Abc@1234');

    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle(); // ensures all animations & futures finish

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
