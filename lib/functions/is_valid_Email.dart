import 'package:flutter_testing_lab/functions/input_validator.dart';

class IsValidEmail implements InputValidator {
  @override
  bool isValidEmail({required String email, required RegExp emailRegex}) {
    return email.contains(emailRegex);
  }
}
