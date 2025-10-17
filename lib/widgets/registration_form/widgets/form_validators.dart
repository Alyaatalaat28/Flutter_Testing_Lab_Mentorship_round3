// lib/validators/validators.dart
import 'package:flutter_testing_lab/helper/extentions.dart';

class FormValidators {
  //========================== التحقق من الاسم
  static String? validateName(String? value) {
    if (value.isStringNullOrEmpty()) {
      return 'Please enter your full name';
    }
    if (value!.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
 //========================= التحقق من الإيميل
  static String? validateEmail(String? value) {
    if (value.isStringNullOrEmpty()) {
      return 'Please enter your email';
    }
    if (!value!.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

 
  //======================== التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value.isStringNullOrEmpty()) {
      return 'Please enter a password';
    }
    
    // if (!RegExp(r'^.{8,}$').hasMatch(value!)) {
    //   return 'Password must be at least 8 characters';
    // }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value!)) {
      return 'Password must contain lowercase letter';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain a number';
    }
    if (!RegExp(r'(?=.*[#?@$%!^%*?&-])').hasMatch(value)) {
      return 'Password must contain special character';
    }
    return null;
  }

  //=========================== التحقق من تأكيد كلمة المرور
  static String? validateConfirmPassword(String? value, String password) {
    if (value.isStringNullOrEmpty()) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}