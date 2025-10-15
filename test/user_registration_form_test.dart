import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('registration widget test', () {
    testWidgets('not accept empty data ', (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(home: UserRegistrationForm()));
      await widgetTester.enterText(find.byKey(ValueKey('name')), '');
      await widgetTester.enterText(find.byKey(ValueKey('emailField')), '');
      await widgetTester.enterText(find.byKey(ValueKey('passwordField')), '');

      await widgetTester.enterText(
        find.byKey(ValueKey('confirm passowrd')),
        '',
      );
      await widgetTester.tap(find.byKey(ValueKey('elevatedbuttonKey')));
      await widgetTester.pumpAndSettle();
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('not accept invalid data ', (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(home: UserRegistrationForm()));

      await widgetTester.enterText(find.byKey(ValueKey('name')), 'a');
      await widgetTester.enterText(find.byKey(ValueKey('emailField')), 'a@');
      await widgetTester.enterText(
        find.byKey(ValueKey('passwordField')),
        '123',
      );

      await widgetTester.tap(find.byKey(ValueKey('elevatedbuttonKey')));
      await widgetTester.pumpAndSettle();
      expect(find.text('Please enter a valid password'), findsOneWidget);
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('accept valid data ', (widgetTester) async {
      await widgetTester.pumpWidget(MaterialApp(home: UserRegistrationForm()));

      await widgetTester.enterText(find.byKey(ValueKey('name')), 'osama');
      await widgetTester.enterText(
        find.byKey(ValueKey('emailField')),
        'osama@gmail.com',
      );
      await widgetTester.enterText(
        find.byKey(ValueKey('passwordField')),
        'Osama@123',
      );
      await widgetTester.enterText(
        find.byKey(ValueKey('confirm passowrd')),
        'Osama@123',
      );

      await widgetTester.tap(find.byKey(ValueKey('elevatedbuttonKey')));
      await widgetTester.pumpAndSettle();
      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });
}
