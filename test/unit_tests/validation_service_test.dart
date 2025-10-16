import 'package:flutter_test/flutter_test.dart';

class ValidationService {
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Full name is required';
    }
    if (RegExp(r'[0-9]').hasMatch(name)) {
      return 'Name should contain only letters';
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (RegExp(r'^\d').hasMatch(email)) {
      return 'Invalid email format (cannot start with a number)';
    }
    if (!RegExp(
      r'^[a-zA-Z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@#$%^&+=]).{8,}$',
    ).hasMatch(password)) {
      return 'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.';
    }

    return null;
  }

  String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}

void main() {
  late ValidationService service;

  setUp(() {
    service = ValidationService();
  });

  group('ValidationService Unit Tests', () {
    // --- Name Validation ---
    group('validateName', () {
      test('should return null for a valid name', () {
        expect(service.validateName('John Doe'), isNull);
      });
      test('should return error for empty name', () {
        expect(service.validateName(''), 'Full name is required');
      });
      test('should return error for name with numbers', () {
        expect(
          service.validateName('John 117'),
          'Name should contain only letters',
        );
      });
    });

    // --- Email Validation ---
    group('validateEmail', () {
      test('should return null for a valid email', () {
        expect(service.validateEmail('user@example.com'), isNull);
      });
      test('should return error if email starts with a digit', () {
        expect(
          service.validateEmail('1user@example.com'),
          'Invalid email format (cannot start with a number)',
        );
      });
      test('should return invalid format error for invalid structure', () {
        expect(service.validateEmail('user@domain'), 'Invalid email format');
      });
    });

    // --- Password Validation ---
    group('validatePassword', () {
      const String formatError =
          'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.';
      test('should return null for a strong password', () {
        expect(service.validatePassword('StrongP@ss123'), isNull);
      });
      test('should return format error for missing symbol', () {
        expect(service.validatePassword('NoSymbol123'), formatError);
      });
      test('should return format error for missing number', () {
        expect(service.validatePassword('NoNumber!A'), formatError);
      });
    });

    // --- Confirm Password Validation ---
    group('validateConfirmPassword', () {
      test('should return null for matching passwords', () {
        expect(service.validateConfirmPassword('Pass123!', 'Pass123!'), isNull);
      });
      test('should return "mismatch" error for non-matching passwords', () {
        expect(
          service.validateConfirmPassword('WrongP@ss1', 'CorrectP@ss1'),
          'Passwords do not match',
        );
      });
    });
  });
}
