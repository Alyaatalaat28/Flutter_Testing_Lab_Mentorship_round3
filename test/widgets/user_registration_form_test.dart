import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('UserRegistrationForm Widget Tests', () {
    testWidgets('should display all form fields', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should display register button', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have 4 TextFormFields', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));
      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets('should show error when submitting empty form', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Full Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsNWidgets(2));
    });

    testWidgets('should show error for empty full name', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.enterText(find.byType(TextFormField).at(0), ' ');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Full Name is required'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.enterText(find.byType(TextFormField).at(1), 'invalidemail');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('should show error for weak password', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.enterText(find.byType(TextFormField).at(2), 'weak');
      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.textContaining('Password must'), findsAtLeast(1));
    });

    testWidgets('should accept text input in all fields', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.enterText(find.byType(TextFormField).at(0), 'Karim Slama');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'karimslama@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Slama@22');
      await tester.enterText(find.byType(TextFormField).at(3), 'Slama@22');

      expect(find.text('Karim Slama'), findsOneWidget);
      expect(find.text('karimslama@gmail.com'), findsOneWidget);
    });

    testWidgets('should show loading indicator when submitting valid form', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.enterText(find.byType(TextFormField).at(0), 'Karim Slama');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'karimslama@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Slama@22');
      await tester.enterText(find.byType(TextFormField).at(3), 'Slama@22');

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Register'), findsNothing);

      await tester.pumpAndSettle();
    });

    testWidgets('should show success message after valid submission', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));
      await tester.enterText(find.byType(TextFormField).at(0), 'Karim Slama');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'karimslama@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Slama@22');
      await tester.enterText(find.byType(TextFormField).at(3), 'Slama@22');

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Registration successful!'), findsOneWidget);
    });

    testWidgets('should disable button while loading', (tester) async {
      await tester.pumpWidget(createTestWidget(const UserRegistrationForm()));

      await tester.enterText(find.byType(TextFormField).at(0), 'Karim Slama');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'karimslama@gmail.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Slama@22');
      await tester.enterText(find.byType(TextFormField).at(3), 'Slama@22');

      await tester.tap(find.text('Register'));
      await tester.pump();
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
      await tester.pumpAndSettle();
    });
  });
}
