import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/registeration_cubit.dart';

void main() {
  late RegisterationCubit cubit;

  setUp(() {
    cubit = RegisterationCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('Email Validation', () {
    test('valid gmail passes', () {
      expect(cubit.isValidEmail('validemail@gmail.com'), true);
    });

    test('invalid email fails and emits failure', () {
      expect(cubit.isValidEmail('invalidemail@outlook.com'), false);
      expect(cubit.state, isA<RegisterationFailure>());
    });
  });

  group('Password Validation', () {
    test('valid password passes', () {
      final result = cubit.isValidPassword('Abcdef1!', 'Abcdef1!');
      expect(result, true);
    });

    test('password too short fails', () {
      final result = cubit.isValidPassword('Ab1!', 'Ab1!');
      expect(result, false);
      expect(cubit.state, isA<RegisterationFailure>());
    });

    test('password mismatch fails', () {
      final result = cubit.isValidPassword('Abcdef1!', 'Abcdef1');
      expect(result, false);
      expect((cubit.state as RegisterationFailure).errMessage,
          contains('Confilm Password'));
    });

    test('missing uppercase fails', () {
      final result = cubit.isValidPassword('abcdef1!', 'abcdef1!');
      expect(result, false);
      expect((cubit.state as RegisterationFailure).errMessage,
          contains('uppercase'));
    });
  });

  group('submitForm', () {
    test('emits success when all valid', () async {
      final expected = [
        isA<RegisterationLoading>(),
        isA<RegisterationSuccess>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.submitForm('Abcdef1!', 'Abcdef1!', 'goodemail@gmail.com');
    });

    test('emits failure when email invalid', () async {

      expectLater(cubit.stream, emitsThrough(isA<RegisterationFailure>()));

      await cubit.submitForm('Abcdef1!', 'Abcdef1!', 'bademail@yahoo.com');
    });
  });
}
