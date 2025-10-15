import 'package:flutter/material.dart';


class Validate {
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }

    if (password.length < 8) {
      return "At least 8 characters with numbers and symbols";
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return "Password must contain at least one uppercase letter";
    }
    if (!hasLowercase) {
      return "Password must contain at least one lowercase letter";
    }
    if (!hasDigit) {
      return "Password must contain at least one Number";
    }
    if (!hasSpecialChar) {
      return "Password must contain at least one special character";
    }

    return null; // Password is valid
  }

  // static String? validatePhone(String? phone) {
  //   var phoneRegExp = RegExp(r'^(0[0-9]{10})$');
  //   var textIsArabic = RegExp(r'^[\0621-\064A0-9 ]+$');
  //   if (phone!.trim().isEmpty) {
  //     return Strings.validPhone.tr;
  //   } else if (!textIsArabic.hasMatch(phone)) {
  //     return Strings.phoneError.tr;
  //   } else if (!phoneRegExp.hasMatch(phone)) {
  //     return Strings.phoneError.tr;
  //   }
  //   return null;
  // }

  // static String? validatePhone(String? phone) {
  //   if (phone!.trim().isEmpty) {
  //     return Strings.validPhone.tr;
  //   } else if (phone.trim().length > 11 || phone.trim().length < 8) {
  //     return Strings.phoneError.tr;
  //   }
  //   return null;
  // }
  static String? validateConfPassword(
      {required String newPassword, required String confPassword}) {
    if (confPassword.isEmpty) {
      return "Confirm Password is required";
    } else if (newPassword.characters == confPassword.characters) {
      return null;
    } else {
      return "Passwords don't match";
    }
  }



  static String? validateNormalString(String? text) {
    if (text == null || text.isEmpty) {
      return "field is required";
    }
    return null;
  }

  static String? validateNormalNumber(String? text) {
    if (text?.isEmpty ?? true) {
      return "Please enter a number";
    }
    if (num.tryParse(text!) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? validateNormalFilterNumber(String? text) {
    // if (text?.isEmpty ?? true) {
    //   return "Please enter a number";
    // }
    if (num.tryParse(text!) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  // static String? validateFilterNumber(String? number, String? startNumber) {
  //   print("nummm: $number, startttt: $startNumber");
  //
  //   // Check if the number is empty
  //   if (number == null || number.trim().isEmpty) {
  //     return null; // Return null if the number is empty, as per your requirements
  //   }
  //
  //   // Ensure both number and startNumber are valid integers
  //   int? parsedNumber = int.tryParse(number);
  //   int? parsedStartNumber =
  //       startNumber != null ? int.tryParse(startNumber) : null;
  //
  //   // Check if parsing failed for number or if startNumber is invalid
  //   if (parsedNumber == null) {
  //     return "Please enter a valid number";
  //   } else if (parsedStartNumber != null && parsedNumber == parsedStartNumber) {
  //     return Strings.filterNumError.tr; // Return error if numbers match
  //   }

    // Ensure parsedStartNumber is valid and check if parsedNumber is less than parsedStartNumber
  //   if (parsedStartNumber != null && parsedNumber < parsedStartNumber) {
  //     return Strings.filterNumEnd.tr; // Return error if parsedNumber is less than parsedStartNumber
  //   }
  //
  //   // If all conditions are met, return null (indicating no error)
  //   return null;
  // }

  // static String? validateFilterNumber(String? number,String? startNumber) {
  //   if (number!.trim().isEmpty) {
  //     return null;
  //   } else if(startNumber!=null&&(int.parse(number)==int.parse(startNumber??''))){
  //     return Strings.filterNumError.tr;
  //   }
  //   if (num.tryParse(number) == null) {
  //     return "Please enter a valid number";
  //   }
  //   return null;
  // }
  static String? validateDropDown(dynamic value) {
    return value == null ? "Select one" : null;
  }

  static String? validatePhoneOptional(String? phone) {
    if (phone == null || phone
        .trim()
        .isEmpty) {
      return "Phone field is required";
    } else {
      // Define the regex pattern for a Saudi phone number
      // final saudiPhonePattern = RegExp(r'^\+966\d{9}$');
      //
      // // Check if the phone number matches the pattern
      // if (!saudiPhonePattern.hasMatch(phone)) {
      //   return Strings.matchSaudiNum.tr;
      // }

      return null; // Return null if the phone number is valid
    }
  }
  static validateFullName(String? name) {
    if (name == null) return "Full name is required";
    if (name.trim().isEmpty) {
      return "Full name is required";
    }
    return null;
  }

  static validateEmail(String? email) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)$");
    if (email!.trim().isEmpty) {
      return "Email is required";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  // static validateFlat(String? flat) {
  //   if (flat!.trim().isEmpty) {
  //     return Strings.flatValid.tr;
  //   }
  //   return null;
  // }
}
