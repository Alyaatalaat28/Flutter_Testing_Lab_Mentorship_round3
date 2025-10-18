class Validator {
  
    bool isValidEmail(String email) {
      final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return email.contains(emailRegex);
  }

  bool isValidPassword(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$');
    return passwordRegex.hasMatch(password);
  }
}