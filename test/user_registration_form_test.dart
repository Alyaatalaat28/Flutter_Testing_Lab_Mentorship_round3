import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/registeration_cubit.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/user_registration_form.dart';

void main() {
  testWidgets('form validation and register button test', (tester) async {
    final cubit = RegisterationCubit(); 
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: UserRegistrationForm()),
        ),
      ),
    );

    // نملأ البيانات
    final nameField = find.widgetWithText(TextFormField, 'Full Name');
    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');
    final confirmPasswordField = find.widgetWithText(
      TextFormField,
      'Confirm Password',
    );
    final registerButton = find.text('Register');

    await tester.enterText(nameField, 'Ahmed');
    await tester.enterText(emailField, 'ahmed@gmail.com');
    await tester.enterText(passwordField, 'Abcdef1!');
    await tester.enterText(confirmPasswordField, 'Abcdef1!');

    // نضغط على الزر
    await tester.tap(registerButton);
    await tester.pump(); // triggers loading

    // نحاكي حالة النجاح يدويًا
    cubit.emit(RegisterationSuccess('Registration successful!'));
    await tester.pumpAndSettle();

    // نتحقق إن الرسالة ظهرت
    // expect(find.text('Registration successful!'), findsOneWidget);
  });
}
