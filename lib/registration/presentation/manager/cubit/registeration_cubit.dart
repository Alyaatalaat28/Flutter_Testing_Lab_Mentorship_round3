import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'registeration_state.dart';

class RegisterationCubit extends Cubit<RegisterationState> {
  RegisterationCubit() : super(RegisterationInitial());

  bool isValidEmail(String email) {
    if (email.length > 15 && email.endsWith('@gmail.com')) return true;
    emit(RegisterationFailure('Invalid email address'));
    return false;
  }

  bool isValidPassword(String password, String confirmPassword) {
    if (password.length < 8) {
      emit(RegisterationFailure('Password must be at least 8 characters'));
      return false;
    } else if (confirmPassword != password) {
      emit(
        RegisterationFailure(' Confilm Password does not match with password'),
      );
      return false;
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      emit(
        RegisterationFailure(
          'Password must contain at least one uppercase letter [A-Z]',
        ),
      );
      return false;
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      emit(
        RegisterationFailure(
          'Password must contain at least one lowercase letter [a-z]',
        ),
      );
      return false;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      emit(
        RegisterationFailure('Password must contain at least one number [0-9]'),
      );
      return false;
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      emit(
        RegisterationFailure(
          'Password must contain at least one special character [!@#\$%^&*(),.?":{}|<>]',
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> submitForm(
    String password,
    String confirmPassword,
    String email,
  ) async {
    emit(RegisterationLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (isValidEmail(email) && isValidPassword(password, confirmPassword)) {
        emit(RegisterationSuccess('Registration successful!')); 
      }
    } catch (e) {
      emit(RegisterationFailure(e.toString()));
    }
  }
}
