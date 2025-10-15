

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/helpers/validators.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  
   group('Email Validation Tests', () {
 test('Email Validation with Regex for a valid email', () {
    //Following the AAA pattern

      //Arrange
      String email ="riad@gmail.com";
      //Act
      bool isValid = Validators.isValidEmail(email);
      //Assert
    expect(isValid, true);
  });

  test('Email Validation with Regex for an invalid email', () {
    //Following the AAA pattern

      //Arrange
      String email ="riad@x";
      //Act
      bool isValid = Validators.isValidEmail(email);
      //Assert
    expect(isValid, false);
  });

  });


  group('Password Validation Tests', (){
  test('password validation with Regex for a valid password', () {
    //Following the AAA pattern

      //Arrange
      String password ="Riad@123";
      //Act
      bool isValid = Validators.isValidPassword(password);
      //Assert
    expect(isValid, true);
  });

  test('password validation with Regex for an invalid password', () {
    //Following the AAA pattern

      //Arrange
      String password ="Riad123";
      //Act
      bool isValid = Validators.isValidPassword(password);
      //Assert
    expect(isValid, false);
  });

  });

  group('Form Validation Tests', (){
  test('form validation for empty values', (){
    //arrange
    String email = "";
    String password = "";
    //act
    bool isEmptyEmail = Validators.isEmpty(email);
    bool isEmptyPassword = Validators.isEmpty(password);
  
     //assert
     expect(true, isEmptyEmail);
     expect(true, isEmptyPassword);
  });



    test('form validation for nonempty values', (){
    //arrange
    String email = "riad@gmail.com";
    String password = "Riad@123";
    //act
    bool isEmptyEmail = Validators.isEmpty(email);
    bool isEmptyPassword = Validators.isEmpty(password);
  
     //assert
     expect(false, isEmptyEmail);
     expect(false, isEmptyPassword);
  });

  });


}