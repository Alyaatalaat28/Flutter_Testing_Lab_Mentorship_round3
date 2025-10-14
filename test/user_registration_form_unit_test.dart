import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/validation_helper.dart';

// Validation functions to test

void main() {
  group('Name Validation Unit Tests', () {
    test('should return "Please enter your full name" if name is empty', () {
      expect(nameValidation(""), "Please enter your full name");
    });

    test(
      'should return "Name must be at least 2 characters" if name length less than 2',
      () {
        expect(nameValidation("M"), "Name must be at least 2 characters");
      },
    );

    test('should return null if it is valid name', () {
      expect(nameValidation("Mahmoud Abdelmoez"), null);
    });
  });

  group('Email Validation Unit Tests', () {
    test('should return "Please enter your email" if email is empty', () {
      expect(emailValidation(""), "Please enter your email");
    });

    test('should return "Please enter a valid email" if email without @', () {
      expect(
        emailValidation("mahmoudmoaz55.com"),
        "Please enter a valid email",
      );
    });

    test(
      'should return "Please enter a valid email" if email without domain',
      () {
        expect(
          emailValidation("mahmoudmoaz55@.com"),
          "Please enter a valid email",
        );
        expect(emailValidation("mahmoudmoaz55@"), "Please enter a valid email");
      },
    );

    test('should return "Please enter a valid email" if email without TLD', () {
      expect(
        emailValidation("mahmoudmoaz55@gmail"),
        "Please enter a valid email",
      );
    });

    test(
      'should return "Please enter a valid email" if email contain space',
      () {
        expect(
          emailValidation("mahmoud moaz55@gmail.com"),
          "Please enter a valid email",
        );
      },
    );

    test('should return null if it is valid email', () {
      expect(emailValidation("mahmoudmoaz55@gmail.com"), null);
    });
  });

  group('Password Validation Unit Tests', () {
    test('should return null for strong password', () {
      expect(passwordValidation('Password123!'), null);
      expect(passwordValidation('asdqwe123!'), null);
      expect(passwordValidation('MyP@ssw0rd'), null);
      expect(passwordValidation('Secure1#'), null);
    });

    test('should return "Please enter a password" for empty password', () {
      expect(passwordValidation(''), "Please enter a password");
    });

    test(
      'should return "Password is too weak" for password without numbers',
      () {
        expect(passwordValidation('password!@#'), "Password is too weak");
      },
    );

    test(
      'should return "Password is too weak" for password without special characters',
      () {
        expect(passwordValidation('password123'), "Password is too weak");
      },
    );

    test(
      'should return "Password is too weak" for password less than 8 characters',
      () {
        expect(passwordValidation('Pass1!'), "Password is too weak");
      },
    );

    test(
      'should return "Password is too weak" for password with only letters',
      () {
        expect(passwordValidation('passwordonly'), "Password is too weak");
      },
    );

    test('should return false for password with only numbers', () {
      expect(passwordValidation('12345678'), "Password is too weak");
    });
  });

  group('Password Confirmation Tests', () {
    test('should return null for identical passwords', () {
      String password = 'Password123!';
      String confirmPassword = 'Password123!';
      expect(confirmPasswordValidation(confirmPassword, password), null);
    });

    test(
      'should return "Please confirm your password" for empty Confirm Password ',
      () {
        String password = 'Password123!';
        String confirmPassword = '';
        expect(
          confirmPasswordValidation(confirmPassword, password),
          "Please confirm your password",
        );
      },
    );

    test(
      'should return "Passwords do not match" for not identical passwords',
      () {
        String password = 'Password123!';
        String confirmPassword = 'password456!';
        expect(
          confirmPasswordValidation(confirmPassword, password),
          "Passwords do not match",
        );
      },
    );
  });
}
