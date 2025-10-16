import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/registeration_cubit.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/register_button_and_text_widget.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/registration_field_section.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegistrationFieldSection(
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
            ),
            BlocProvider(
              create: (context) => RegisterationCubit(),
              child: RegisterButtonAndTextWidget(
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                formKey: formKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
