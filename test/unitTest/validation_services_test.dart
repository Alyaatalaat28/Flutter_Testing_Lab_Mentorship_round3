import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  late ValidationService validation;

  setUp(() {
    validation = ValidationService();
  });

  group('ValidationService Tests', () {
    test('validateName returns error for empty name', () {
      expect(validation.validateName(''), 'Full name is required');
      expect(validation.validateName(null), 'Full name is required');
    });

    test('validateName returns error for invalid characters', () {
      expect(
        validation.validateName('John123'),
        'Name should contain only letters and spaces',
      );
    });

    test('validateName returns null for valid name', () {
      expect(validation.validateName('John Doe'), null);
    });

    test('validateEmail returns error for empty email', () {
      expect(validation.validateEmail(''), 'Email is required');
      expect(validation.validateEmail(null), 'Email is required');
    });

    test('validateEmail returns error for invalid email', () {
      expect(
        validation.validateEmail('123test@example.com'),
        'Invalid email format (only letters allowed in local part)',
      );
    });

    test('validateEmail returns null for valid email', () {
      expect(validation.validateEmail('test@example.com'), null);
    });

    test('validatePassword returns error for empty password', () {
      expect(validation.validatePassword(''), 'Password is required');
      expect(validation.validatePassword(null), 'Password is required');
    });

    test('validatePassword returns error for weak password', () {
      expect(
        validation.validatePassword('weak'),
        'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.',
      );
    });

    test('validatePassword returns null for strong password', () {
      expect(validation.validatePassword('Passw0rd#'), null);
    });

    test('validateConfirmPassword returns error for empty field', () {
      expect(
        validation.validateConfirmPassword('', 'Passw0rd#'),
        'Please confirm your password',
      );
      expect(
        validation.validateConfirmPassword(null, 'Passw0rd#'),
        'Please confirm your password',
      );
    });

    test('validateConfirmPassword returns error if passwords do not match', () {
      expect(
        validation.validateConfirmPassword('Passw0rd!', 'Passw0rd#'),
        'Passwords do not match',
      );
    });

    test('validateConfirmPassword returns null if passwords match', () {
      expect(
        validation.validateConfirmPassword('Passw0rd#', 'Passw0rd#'),
        null,
      );
    });
  });
}
