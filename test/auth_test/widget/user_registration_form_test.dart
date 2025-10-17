
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/feature/auth_feature/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('shows error messages when fields are empty', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      // Act
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      await tester.enterText(find.byType(TextFormField).at(0), 'Ahmed Samy'); // name
      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email'); // email
      await tester.enterText(find.byType(TextFormField).at(2), 'Ahmed@123'); // password
      await tester.enterText(find.byType(TextFormField).at(3), 'Ahmed@123'); // confirm password
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows password validation error for weak password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      await tester.enterText(find.byType(TextFormField).at(0), 'Ahmed Samy'); // name
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com'); // email
      await tester.enterText(find.byType(TextFormField).at(2), '123456'); // weak password
      await tester.enterText(find.byType(TextFormField).at(3), '123456'); // confirm password
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('shows success message when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      await tester.enterText(find.byType(TextFormField).at(0), 'Ahmed Samy');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'Ahmed@123');
      await tester.enterText(find.byType(TextFormField).at(3), 'Ahmed@123');

      await tester.tap(find.text('Register'));
      await tester.pump(const Duration(seconds: 2)); // simulate delay
      await tester.pumpAndSettle();

      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });
}