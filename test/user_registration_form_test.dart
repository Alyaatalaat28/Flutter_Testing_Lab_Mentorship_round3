import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/helpers/validators.dart';

void main() {
  group('test registration form', () {
    test('empty email shoud regicted in email validation', () {
      expect(Validators.isEmailValid(''), false);
    });

    test('empty in example like a@  should be rejected', () {
      expect(Validators.isEmailValid('a@'), false);
    });
    test('empty in example like @b  should be rejected', () {
      expect(Validators.isEmailValid('@b'), false);
    });
    test('short password should be rejected', () {
      expect(Validators.isPasswordValid('123'), false);
    });

    test('correct email like osama@gmail.com is accepted', () {
      expect(Validators.isEmailValid('osama@gmail.com'), true);
    });
    test('password with 6 length and special char is accepted ', () {
      expect(Validators.isPasswordValid('Osama@123'), true);
    });
  });
}
