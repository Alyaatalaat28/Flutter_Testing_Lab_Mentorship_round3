// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing_lab/main.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {

 testWidgets('Form Widget Test for invalid email and password', (tester) async {
      await tester.pumpWidget( MaterialApp(home: Scaffold(body: UserRegistrationForm(),),));

      final emailInput = find.byKey(const Key('emailInput'));
      final passwordInput = find.byKey(const Key('passwordInput'));
      final submitButton = find.byKey(const Key('registerButton'));

      await tester.enterText(emailInput, 'riad@x');
      await tester.enterText(passwordInput, '124214');

      await tester.tap(submitButton);

         await tester.pump();


         expect(find.text('Please enter a valid email'), findsOneWidget);
                expect(find.text('Password is too weak'), findsOneWidget);

       // Test code goes here.
  });



  testWidgets('Form Widget Test for valid email and password', (tester) async {
       await tester.pumpWidget( MaterialApp(home: Scaffold(body: UserRegistrationForm(),),));
     final emailInput = find.byKey(const Key('emailInput'));
      final passwordInput = find.byKey(const Key('passwordInput'));
      final submitButton = find.byKey(const Key('registerButton'));

      await tester.enterText(emailInput, 'riad@gmail.com');
      await tester.enterText(passwordInput, 'Riad@123');

      await tester.tap(submitButton);

         await tester.pump();

      // this should cause an error, because im passing a valid email and password
         expect(find.text('Please enter a valid email'), findsOneWidget);
                expect(find.text('Password is too weak'), findsOneWidget);

 
  });



}
