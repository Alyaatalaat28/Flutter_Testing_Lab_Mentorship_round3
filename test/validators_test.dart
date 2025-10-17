import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/validators.dart';

void main() {
  group('Email Validation', () {
    test('Valid email returns true', () {
      expect(isValidEmail('test@example.com'), true);
    });

    test('Invalid email returns false', () {
      expect(isValidEmail('a@'), false);
      expect(isValidEmail('@b.com'), false);
      expect(isValidEmail('test.com'), false);
    });
  });

  group('Password Validation', () {
    test('Strong password returns true', () {
      expect(isValidPassword('Abc@1234'), true);
    });

    test('Weak passwords return false', () {
      expect(isValidPassword('abc123'), false);
      expect(isValidPassword('ABC123'), false);
      expect(isValidPassword('Abcdefgh'), false);
    });
  });
}
