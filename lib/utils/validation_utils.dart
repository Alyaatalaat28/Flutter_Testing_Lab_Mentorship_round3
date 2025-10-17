class ValidationUtils {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }
}
