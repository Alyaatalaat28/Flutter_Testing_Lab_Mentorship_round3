import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validation', () {
    test('Valid email passes', () {
      expect(_validEmail('test@example.com'), true);
    });

    test('Invalid email fails', () {
      expect(_validEmail('a@'), false);
      expect(_validEmail('@b'), false);
      expect(_validEmail('test.com'), false);
    });
  });

  group('Password Validation', () {
    test('Strong password passes', () {
      expect(_validPassword('Abc@1234'), true);
    });

    test('Weak password fails', () {
      expect(_validPassword('abc123'), false);
      expect(_validPassword('ABCDEFGH'), false);
      expect(_validPassword('Abc12345'), false);
    });
  });
}

// Helpers (copy نفس الدوال من الفورم)
bool _validEmail(String email) {
  final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
  return regex.hasMatch(email);
}

bool _validPassword(String password) {
  final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');
  return regex.hasMatch(password);
}
