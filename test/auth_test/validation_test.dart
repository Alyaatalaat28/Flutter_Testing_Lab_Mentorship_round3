import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/validators.dart';

void main() {
  group('Email validation', () {
    test('valid email passes', () {
      expect(isValidEmail('test@example.com'), isTrue);
      expect(isValidEmail('user.name+tag@sub.domain.co'), isTrue);
    });

    test('invalid emails fail', () {
      expect(isValidEmail('a@'), isFalse);
      expect(isValidEmail('@b.com'), isFalse);
      expect(isValidEmail('userexample.com'), isFalse);
      expect(isValidEmail(' user@site.com '), isTrue); // trimmed
    });
  });

  group('Password validation', () {
    test('strong passwords pass', () {
      // استخدم قيم وهمية بدل اللي شكلها حقيقي
      expect(isValidPassword('Fakepass@1234'), isTrue);
      expect(isValidPassword('Dummy!1234'), isTrue);
    });

    test('weak passwords fail', () {
      expect(isValidPassword('12345678'), isFalse); // no letters/symbols
      expect(isValidPassword('password'), isFalse); // no digits/symbols/caps
      expect(isValidPassword('Test1234'), isFalse); // no symbol
      expect(isValidPassword('Aa@1'), isFalse); // too short
    });
  });
}
