class Validation {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    if (password.length < 8) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    return true;
  }

  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    if (name.length < 2) return false;
    return true;
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword && password.isNotEmpty;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!isValidPassword(value)) {
      return 'Password is too weak';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
