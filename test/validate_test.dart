import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utilities/validate.dart'; // عدّلي المسار حسب مكان الملف فعليًا

void main() {
  group('Validation Tests', () {
    test('Full name is required', () {
      expect(Validate.validateFullName(''), 'Full name is required');
    });

    test('Full name should be valid', () {
      expect(Validate.validateFullName('Fatma Ahmed'), null);
    });

    test('Email is required', () {
      expect(Validate.validateEmail(''), 'Email is required');
    });

    test('Email should be valid', () {
      expect(Validate.validateEmail('test@example.com'), null);
    });

    test('Email should be invalid', () {
      expect(Validate.validateEmail('invalid_email'), 'Please enter a valid email');
    });

    test('Password should not be empty', () {
      expect(Validate.validatePassword(''), 'Password is required');
    });

    test('Password should be strong', () {
      expect(Validate.validatePassword('123'), 'At least 8 characters with numbers and symbols');
    });

    test('Password should be valid', () {
      expect(Validate.validatePassword('Test@1234'), null);
    });

    test('Confirm password should match', () {
      expect(
        Validate.validateConfPassword(
          newPassword: 'Test@1234',
          confPassword: 'Test@1234',
        ),
        null,
      );
    });

    test('Confirm password should fail if not matching', () {
      expect(
        Validate.validateConfPassword(
          newPassword: 'Test@1234',
          confPassword: 'WrongPass',
        ),
        'Passwords don\'t match',
      );
    });
  });
}
