import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/validators.dart';
void main() {
  group('Email Validator', () {
    test('Valid emails should pass', () {
      expect(Validators.isValidEmail('test@example.com'), isTrue);
      expect(Validators.isValidEmail('user.name@domain.co'), isTrue);
    });

    test('Invalid emails should fail', () {
      expect(Validators.isValidEmail('a@'), isFalse);
      expect(Validators.isValidEmail('@b.com'), isFalse);
      expect(Validators.isValidEmail('plainaddress'), isFalse);
    });
  });

  group('Password Validator', () {
    test('Empty or short passwords should fail', () {
      expect(Validators.passwordValidator(''), isNotNull);
      expect(Validators.passwordValidator('short'), isNotNull);
    });

    test('Passwords missing requirements should fail', () {
      expect(Validators.passwordValidator('Password'), isNotNull); // no number or symbol
      expect(Validators.passwordValidator('password1'), isNotNull); // no uppercase or symbol
      expect(Validators.passwordValidator('Password1'), isNotNull); // no symbol
    });

    test('Strong password should pass', () {
      expect(Validators.passwordValidator('Password1!'), isNull);
    });
  });

  group('Name Validator', () {
    test('Empty name fails', () {
      expect(Validators.nameValidator(''), isNotNull);
    });

    test('Short name fails', () {
      expect(Validators.nameValidator('A'), isNotNull);
    });

    test('Proper name passes', () {
      expect(Validators.nameValidator('John Doe'), isNull);
    });
  });
}
