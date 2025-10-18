// lib/validators.dart

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email.trim());
}

bool isValidPassword(String password) {
  final passwordRegex =
  RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*~]).{8,}$');
  return passwordRegex.hasMatch(password);
}
