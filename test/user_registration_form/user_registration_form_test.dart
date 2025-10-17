import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/validation_utils.dart';

void main() {
  group('Validation Logic Tests', () {
    test('Valid email should pass', () {
      expect(ValidationUtils.isValidEmail('test@example.com'), true);
    });

    test('Invalid emails should fail', () {
      expect(ValidationUtils.isValidEmail('a@'), false);
      expect(ValidationUtils.isValidEmail('@b'), false);
      expect(ValidationUtils.isValidEmail('a@b'), false);
      expect(ValidationUtils.isValidEmail('a@b.'), false);
    });

    test('Valid password should pass', () {
      expect(ValidationUtils.isValidPassword('Pass@123'), true);
    });

    test('Weak passwords should fail', () {
      expect(ValidationUtils.isValidPassword('12345678'), false);
      expect(ValidationUtils.isValidPassword('password'), false);
      expect(ValidationUtils.isValidPassword('P@ss'), false);
    });
  });
}
