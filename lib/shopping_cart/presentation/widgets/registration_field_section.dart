import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/custom_text_form_field.dart';

class RegistrationFieldSection extends StatelessWidget {
  const RegistrationFieldSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });
  final TextEditingController nameController,
      emailController,
      passwordController,
      confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          nameController: nameController,
          labelText: "Full Name",
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          nameController: emailController,
          labelText: "Email",
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          nameController: passwordController,
          labelText: "Password",
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          nameController: confirmPasswordController,
          labelText: "Confirm Password",
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
