class Validators {
  // Returns true if email looks valid.
  static bool isValidEmail(String email) {
    // RFC-like-ish simple regex that rejects "a@" "@b" etc.
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z]{2,})+$",
    );
    return emailRegex.hasMatch(email.trim());
  }

  // Returns null if the value is valid, otherwise returns an error message
  // (useful for TextFormField.validator).
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    final password = value.trim();

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    final hasDigit = RegExp(r'\d').hasMatch(password);
    if (!hasDigit) {
      return 'Password must contain at least one number';
    }

    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\\/\[\];]').hasMatch(password);
    if (!hasSpecial) {
      return 'Password must contain at least one special character';
    }

    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    if (!hasUpper) {
      return 'Password should contain at least one uppercase letter';
    }

    return null; // valid
  }

  // Simple name validator (optional)
  static String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Email validator suitable for TextFormField.validator
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
