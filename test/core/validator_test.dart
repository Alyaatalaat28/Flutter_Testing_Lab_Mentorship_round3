import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/validator.dart';

void main() {
  group('validateEmail', () {
    /// VALID EMAILS
    test('should return null for valid email', () {
      final email = 'test@example.com';

      final validateEamail = Validator.validateEmail(email);

      expect(validateEamail, isNull);
    });

    test('should return null for email with numbers', () {
      final email = 'test123@example.com';

      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, isNull);
    });

    test('should return null for email with dots', () {
      final email = 'test.test@example.com';

      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, isNull);
    });

    /// INVALID EMAILS
    test('should return error for null email', () {
      final email = Validator.validateEmail(null);

      expect(email, isNotNull);
      expect(email, 'Email is required');
    });

    test('should return error for empty email', () {
      final email = '';
      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, 'Email is required');
    });

    test('should return error for email without @', () {
      final email = 'testexample.com';
      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, isNotNull);
      expect(validateEmail, 'Invalid email address');
    });

    test('should return error for email without domain', () {
      final email = 'test@';
      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, isNotNull);
      expect(validateEmail, 'Invalid email address');
    });

    test('should return error for email without extension', () {
      final email = 'test@example';

      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, isNotNull);
      expect(validateEmail, 'Invalid email address');
    });

    test('should return error for email with spaces', () {
      final email = 'test example.com';
      final validateEmail = Validator.validateEmail(email);

      expect(validateEmail, isNotNull);
      expect(validateEmail, 'Invalid email address');
    });

    test('should return error for email ending with dot', () {
      final email = 'test@example.com.';
      final validateEmail = Validator.validateEmail(email);
      expect(validateEmail, isNotNull);
    });
  });

  group('validateEmptyText', () {
    final fieldName = 'Full Name';
    test('should return null for non-empty text', () {
      final text = 'test';
      final validateText = Validator.validateEmptyText(fieldName, text);
      expect(validateText, isNull);
    });

    test('should return error for empty text', () {
      final text = '';
      final validateText = Validator.validateEmptyText(fieldName, text);

      expect(validateText, isNotNull);
      expect(validateText, equals('Full Name is required'));
    });

    test('should return error for null text', () {
      final text = null;
      final validateText = Validator.validateEmptyText(fieldName, text);

      expect(validateText, isNotNull);
      expect(validateText, equals('Full Name is required'));
    });

    test('should return error for text with spaces only', () {
      final text = '     ';
      final validateText = Validator.validateEmptyText(fieldName, text);

      expect(validateText, isNotNull);
      expect(validateText, equals('Full Name is required'));
    });
  });

  group('validatePassword', () {
    test('should return null for valid password', () {
      final password = 'Password123!';

      final validatePassword = Validator.validatePassword(password);

      expect(validatePassword, isNull);
    });

    test(
      'should return null for password with multiple special characters',
      () {
        final password = 'Str0ng!P@ss#';
        final validatePassword = Validator.validatePassword(password);
        expect(validatePassword, isNull);
      },
    );

    test('should return error for null password', () {
      final password = null;
      final validatePassword = Validator.validatePassword(password);

      expect(validatePassword, equals('Password is required'));
    });

    test('should return error for empty password', () {
      final password = '';
      final result = Validator.validatePassword(password);
      expect(result, equals('Password is required'));
    });

    test('should return error for password less than 8 characters', () {
      final password = 'Test@12';
      final result = Validator.validatePassword(password);

      expect(result, equals('Password must be at least 8 characters long'));
    });

    test('should return error for password without uppercase letter', () {
      final password = 'test@123';
      final result = Validator.validatePassword(password);

      expect(
        result,
        equals('Password must contain at least one uppercase letter'),
      );
    });

    test('should return error for password without lowercase letter', () {
      final result = Validator.validatePassword('TEST@1234');
      expect(
        result,
        equals('Password must contain at least one lowercase letter'),
      );
    });

    test('should return error for password without number', () {
      final password = 'Test@test';
      final result = Validator.validatePassword(password);
      expect(
        result,
        equals('Password must contain at least one number letter'),
      );
    });

    test('should return error for password without special character', () {
      final password = 'Test1234';
      final result = Validator.validatePassword(password);

      expect(
        result,
        equals('Password must contain at least one special character'),
      );
    });

    test('should return error for password with only numbers', () {
      final password = '12345678';
      final result = Validator.validatePassword(password);
      expect(result, isNotNull);
    });

    test('should return error for password with only letters', () {
      final password = 'Testvalidatepassword';
      final result = Validator.validatePassword(password);
      expect(result, isNotNull);
    });

    test('should accept different special characters', () {
      final specialCharachter = [
        '!',
        '@',
        '#',
        '\$',
        '%',
        '^',
        '&',
        '*',
        '-',
        '?',
      ];
      for (final char in specialCharachter) {
        final password = 'Test${char}1234';
        final validatePassword = Validator.validatePassword(password);

        expect(validatePassword, isNull, reason: 'Failed for special char: $char');
      }
    });
  });
}
