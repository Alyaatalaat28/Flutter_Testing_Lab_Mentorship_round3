import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('should show error when name is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('should show error when name is too short', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'A');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('should show error when email is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'mahmoudmoaz');

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should accept valid email format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'mahmoudmoaz55@gmail.com',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsNothing);
    });

    testWidgets('should show error when password is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('should show error for weak password (no numbers)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(2), 'kjhgggkg!@#');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error for weak password (no special characters)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(2), 'kgkihhkh123');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error for password less than 8 characters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(2), 'hg1!');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should accept strong password', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(2), 'asdqwe123!');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Password is too weak'), findsNothing);
    });

    testWidgets('should show error when confirm password is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(2), 'asdqwe123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'qweasd456!');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should submit successfully with valid inputs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Mahmoud Abdelmoez',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'mahmoudmoaz55@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');

      await tester.tap(find.text('Register'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for async operation to complete
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });
}
