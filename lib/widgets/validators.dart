abstract class Validators {
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;

    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@'
      r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
      r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );

    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String? password) {
    // Check for null or empty
    if (password == null || password.isEmpty) return false;

    // Check minimum length
    if (password.length < 8) return false;

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;

    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(password)) return false;

    // Check for at least one special character
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>~_\-+=\[\]\\\/]').hasMatch(password))
      return false;

    return true;
  }
}
