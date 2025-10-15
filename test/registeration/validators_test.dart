import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/validators.dart';

void main() {
  group('Email validation', () {
    test('accepts valid emails', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('user.name+tag@sub.domain.co'), isTrue);
    });

    test('rejects invalid emails', () {
      expect(Validators.isValidEmail('a@'), isFalse);
      expect(Validators.isValidEmail('@b'), isFalse);
      expect(Validators.isValidEmail('plainaddress'), isFalse);
      expect(Validators.isValidEmail('user@.com'), isFalse);
    });
  });

  group('Password strength validation', () {
    test('accepts strong passwords', () {
      expect(Validators.isStrongPassword('Str0ng!Pass'), isTrue);
      expect(Validators.isStrongPassword('Aa1!aaaa'), isTrue);
    });

    test('rejects weak passwords', () {
      expect(Validators.isStrongPassword('short1!'), isFalse); // too short
      expect(Validators.isStrongPassword('nouppercase1!'), isFalse);
      expect(Validators.isStrongPassword('NOLOWERCASE1!'), isFalse);
      expect(Validators.isStrongPassword('NoSpecial123'), isFalse);
      expect(Validators.isStrongPassword(null), isFalse);
    });
  });
}
