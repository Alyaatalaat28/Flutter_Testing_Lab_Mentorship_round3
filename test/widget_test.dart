// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:flutter_testing_lab/main.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
   test('validates email correctly', () {
    final state = UserRegistrationFormState();
    expect(state.isValidEmail('a@'), false);
    expect(state.isValidEmail('user@gmail.com'), true);
  });

  test('validates password strength', () {
    final state = UserRegistrationFormState();
    expect(state.isValidPassword('abc'), false);
    expect(state.isValidPassword('Abc1!def'), true);
  });
}
