import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/functions/input_validator.dart';
import 'package:flutter_testing_lab/functions/user_registration.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group("Group Method", () {
    late InputValidator interface;
    late bool isEmail;
    setUp(() {
      interface = UserRegistration();
    });

    test("email failure", () {
      isEmail = interface.isValidEmail(email: "dasasasasasa@gmailcom");
      expect(isEmail, false);
    });

    test("email success", () {
      isEmail = interface.isValidEmail(email: "dasasasasasa@gmail.co");
      expect(isEmail, true);
    });

    test("password success", () {
      isEmail = interface.isValidConfirmPassword(
        confirmPassword: "Test123@",
        password: "Test1234@",
      );
      expect(isEmail, true);
    });
  });

  group("group buttn", () {
    late Finder button;

    // testWidgets("test buttn success ", (WidgetTester widgetTester) async {
    //   await widgetTester.pumpWidget(
    //     MaterialApp(home: Scaffold(body: UserRegistrationForm())),
    //   );

    //   button = find.text("Register");
    //   await widgetTester.tap(button);
    //   await widgetTester.pump(Duration(seconds: 2));
    //   expect(find.text("Registration successful!"), findsNothing);
    // });

    testWidgets("test buttn  failure ", (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );
      await widgetTester.enterText(find.byKey(Key("FullName")), "");
      await widgetTester.enterText(find.byKey(Key("Email")), "");
      await widgetTester.enterText(find.byKey(Key("Password")), "");
      await widgetTester.enterText(find.byKey(Key("ConfirmPassword")), "");
      button = find.byKey(Key("Register"));
      await widgetTester.tap(button);
      await widgetTester.pump(Duration(seconds: 2));
      expect(find.text("Registration successful!"), findsNothing);
    });

    testWidgets("test buttn  failure ", (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );
      await widgetTester.enterText(find.byKey(Key("FullName")), "Test");
      await widgetTester.enterText(
        find.byKey(Key("Email")),
        "ayman808sh@gmail.com",
      );
      await widgetTester.enterText(find.byKey(Key("Password")), "Test123@");
      await widgetTester.enterText(
        find.byKey(Key("ConfirmPassword")),
        "Test123@",
      );
      button = find.byKey(Key("Register"));
      await widgetTester.tap(button);
      await widgetTester.pump(Duration(seconds: 2));
      expect(find.text("Registration successful!"), findsOneWidget);
      // expect(find.text(""), findsNothing);
    });
  });
}
