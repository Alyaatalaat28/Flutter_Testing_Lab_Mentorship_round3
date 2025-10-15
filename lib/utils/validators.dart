class Validators {
  // RFC 5322 simplified email regex that's stricter than the previous one.
  // It allows common email formats and rejects inputs like 'a@' or '@b'.
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}"
    r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  // Strong password: at least 8 chars, includes upper, lower, digit and symbol
  static final RegExp _strongPasswordRegExp = RegExp(
    r'''^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*\(\)_\+\-\=\[\]{};:\"\\|,.<>\/?]).{8,}$''',
  );

  static bool isValidEmail(String? email) {
    if (email == null) return false;
    return _emailRegExp.hasMatch(email.trim());
  }

  static bool isStrongPassword(String? password) {
    if (password == null) return false;
    return _strongPasswordRegExp.hasMatch(password);
  }
}
