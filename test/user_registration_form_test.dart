import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';



void main() {
  group('UserRegistrationForm Widget Tests', () {
    
    testWidgets('Form renders correctly in its initial state', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      // Check for key widgets
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
      expect(find.text('Registration successful!'), findsNothing);
      expect(find.text('Please enter your full name'), findsNothing);
    });

    testWidgets('Shows validation errors when form is submitted empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump(); 

    
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Shows validation error for invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

    
      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();


      expect(find.text('Please enter a valid email'), findsOneWidget);
    });
    
    testWidgets('Shows validation errors for weak password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      final passwordField = find.byType(TextFormField).at(2);
      
     
      await tester.enterText(passwordField, 'weak');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();
      expect(find.text('Password must be at least 8 characters long'), findsOneWidget);

      await tester.enterText(passwordField, 'weakpassword');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();
      expect(find.text('Password must contain at least one number'), findsOneWidget);
      
      await tester.enterText(passwordField, 'weakpassword123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();
      expect(find.text('Password must contain at least one special character'), findsOneWidget);
    });

    testWidgets('Shows error when passwords do not match', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));


      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123?');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();
      
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Shows success message on valid submission', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: UserRegistrationForm())));

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'john.doe@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
      

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump(); // Start the loading indicator

    
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      
      await tester.pump(const Duration(seconds: 2));
      
      // Check for success message
      expect(find.text('Registration successful!'), findsOneWidget);
    });
  });
}