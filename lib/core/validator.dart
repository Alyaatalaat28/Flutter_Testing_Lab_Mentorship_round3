class Validator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }

    final parts = value.split('@');
    if (parts.length != 2) {
      return 'Invalid email address';
    }

    final domain = parts[1];

    if (!domain.contains('.')) {
      return 'Invalid email domain';
    }

    if (domain.startsWith('.') || domain.endsWith('.')) {
      return 'Invalid email domain';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number letter';
    }
    if (!value.contains(RegExp(r'[#?!@$%^&*-]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
}
