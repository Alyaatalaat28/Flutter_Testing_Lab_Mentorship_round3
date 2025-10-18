// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

// void main() {
//   testWidgets('Shows validation messages on empty fields', (
//     WidgetTester tester,
//   ) async {
//     await tester.pumpWidget(
//       const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
//     );
//     await tester.pumpAndSettle();

//     final registerButton = find.text('Register');
//     await tester.tap(registerButton);
//     await tester.pumpAndSettle(const Duration(seconds: 3));

//     await tester.pump();

//     expect(find.text('Please enter your full name'), findsOneWidget);
//     expect(find.text('Please enter your email'), findsOneWidget);
//   });

//   testWidgets('Form submits when valid', (WidgetTester tester) async {
//     await tester.pumpWidget(const MaterialApp(home: UserRegistrationForm()));

//     await tester.enterText(find.byType(TextFormField).at(0), 'Shrouk Ahmed');
//     await tester.enterText(
//       find.byType(TextFormField).at(1),
//       'test@example.com',
//     );
//     await tester.enterText(find.byType(TextFormField).at(2), 'Aa1@abcd');
//     await tester.enterText(find.byType(TextFormField).at(3), 'Aa1@abcd');

//     await tester.tap(find.text('Register'));
//     await tester.pump(const Duration(seconds: 2));

//     expect(find.text('Registration successful!'), findsOneWidget);
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('Shows validation messages on empty fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.pumpAndSettle();

    final registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('Form submits when valid', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('nameField')), 'Shrouk Ahmed');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'Aa1@abcd');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'Aa1@abcd',
    );

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
