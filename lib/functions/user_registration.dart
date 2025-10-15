import 'package:flutter_testing_lab/functions/input_validator.dart';

class UserRegistration implements InputValidator {
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
  );
  @override
  bool isValidEmail({required String email}) {
    return email.contains(_emailRegex);
  }

  @override
  bool isValidPassword({required String password}) {
    return password.contains(_passwordRegex);
  }

  @override
  bool isValidConfirmPassword({
    required String confirmPassword,
    required String password,
  }) {
    if (password != confirmPassword) {
      return true;
    } else {
      return false;
    }
  }
}
