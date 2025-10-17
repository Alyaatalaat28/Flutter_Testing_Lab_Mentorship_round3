
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  return emailRegex.hasMatch(email.trim());
}

bool isValidPassword(String password) {

  final passwordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');
  return passwordRegex.hasMatch(password);
}
