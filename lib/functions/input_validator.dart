abstract class InputValidator {
  bool isValidEmail({required String email});
  bool isValidPassword({required String password});
  bool isValidConfirmPassword({
    required String confirmPassword,
    required String password,
  });
}
