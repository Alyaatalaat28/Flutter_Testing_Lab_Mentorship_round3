bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool isValidPassword(String password) {
  if (password.length < 8) return false;
  bool hasNumber = password.contains(RegExp(r'[0-9]'));
  bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  return hasNumber && hasSpecialChar;
}

String? nameValidation(String? name) {
  if (name == null || name.isEmpty) {
    return 'Please enter your full name';
  }
  if (name.length < 2) {
    return 'Name must be at least 2 characters';
  }
  return null;
}

String? emailValidation(String? email) {
  if (email == null || email.isEmpty) {
    return 'Please enter your email';
  }
  if (!isValidEmail(email)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? passwordValidation(String? password) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  }
  if (!isValidPassword(password)) {
    return 'Password is too weak';
  }
  return null;
}

String? confirmPasswordValidation(String? confirmPassword, String password) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Please confirm your password';
  }
  if (confirmPassword != password) {
    return 'Passwords do not match';
  }
  return null;
}
