import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/validators.dart';

void main() {
  group("Registration  Form Validation Test", () {
    test("Should return false when email is null", () {
      expect(Validators.isValidEmail(null), false);
    });
    test("Should return false if email is empty", () {
      expect(Validators.isValidEmail(""), false);
    });
    test('should return false for invalid formats', () {
      expect(Validators.isValidEmail('a@'), false);
      expect(Validators.isValidEmail('@b.com'), false);
      expect(Validators.isValidEmail('abc.com'), false);
      expect(Validators.isValidEmail('abc@com'), false);
      expect(Validators.isValidEmail('abc@.com'), false);
      expect(Validators.isValidEmail('abc@com.'), false);
      expect(Validators.isValidEmail('abc@@example.com'), false);
    });

    test('should return true for valid formats', () {
      expect(Validators.isValidEmail('test@example.com'), true);
      expect(Validators.isValidEmail('user.name@domain.co'), true);
      expect(Validators.isValidEmail('name+tag@gmail.com'), true);
      expect(Validators.isValidEmail('a_b-c@sub.domain.org'), true);
      expect(Validators.isValidEmail('user@[192.168.1.1]'), true);
      expect(Validators.isValidEmail('USER@DOMAIN.COM'), true);
    });

    test("Should return false when password is null", () {
      expect(Validators.isValidPassword(null), false);
    });

    test("Should return false when password is empty", () {
      expect(Validators.isValidPassword(""), false);
    });

    test("Should return false when password is less than 8 characters", () {
      expect(Validators.isValidPassword("Abc12!"), false);
      expect(Validators.isValidPassword("Aa1!"), false);
    });

    test("Should return false when password has no uppercase letter", () {
      expect(Validators.isValidPassword("abcdef123!"), false);
    });

    test("Should return false when password has no lowercase letter", () {
      expect(Validators.isValidPassword("ABCDEF123!"), false);
    });

    test("Should return false when password has no number", () {
      expect(Validators.isValidPassword("Abcdefgh!"), false);
    });

    test("Should return false when password has no special character", () {
      expect(Validators.isValidPassword("Abcdefgh123"), false);
    });

    test("Should return true for valid strong passwords", () {
      expect(Validators.isValidPassword("Password123!"), true);
      expect(Validators.isValidPassword("MyP@ssw0rd"), true);
      expect(Validators.isValidPassword("Str0ng#Pass"), true);
      expect(Validators.isValidPassword("Test123\$Password"), true);
      expect(Validators.isValidPassword("abCD1234!@#"), true);
    });
  });
}
