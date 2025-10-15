// lib/validators.dart
class Validators {
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {

    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*]).{8,}$');
    return regex.hasMatch(password);
  }

  static bool isEmpty (String value) {
    return value.isEmpty;
  }
}