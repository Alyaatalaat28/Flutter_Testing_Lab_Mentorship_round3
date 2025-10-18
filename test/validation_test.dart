import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/validation.dart';

void main() {
  group('Email Validation', () {
    test('Valid emails should pass', () {
      expect(Validation.isValidEmail('test@example.com'), true);
      expect(Validation.isValidEmail('user.name@domain.co'), true);
    });

    test('Invalid emails should fail', () {
      expect(Validation.isValidEmail('a@'), false);
      expect(Validation.isValidEmail('@b.com'), false);
      expect(Validation.isValidEmail('abc'), false);
    });
  });

  group('Password Validation', () {
    test('Strong password should pass', () {
      expect(Validation.isValidPassword('Aa1@abcd'), true);
    });

    test('Weak passwords should fail', () {
      expect(Validation.isValidPassword('12345'), false);
      expect(Validation.isValidPassword('abcdefg'), false);
      expect(Validation.isValidPassword('ABCDEF1'), false);
    });
  });
}
