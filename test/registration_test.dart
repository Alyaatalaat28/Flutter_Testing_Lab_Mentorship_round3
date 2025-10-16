import 'package:flutter_test/flutter_test.dart';
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
