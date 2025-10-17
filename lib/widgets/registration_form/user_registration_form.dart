import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/registration_form/widgets/custom_text_field.dart';
import 'package:flutter_testing_lab/widgets/registration_form/widgets/form_validators.dart';
import 'package:flutter_testing_lab/widgets/registration_form/widgets/register_btn.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  String _message = '';

  Future<void> btnOnPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _message = 'Registration successful!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //========================= name =====================
            CustomTextField(
              controller: _nameController,
              labelText: 'Full Name',
              validator: FormValidators.validateName,
            ),
            const SizedBox(height: 16),

            //======================= email ====================
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: FormValidators.validateEmail,
            ),
            const SizedBox(height: 16),

            //======================= password ================
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
              helperText:
                  'At least 8 chars, uppercase, lowercase, number, symbol',
              validator: FormValidators.validatePassword,
            ),
            const SizedBox(height: 16),

            //======================= comfirmPassword ===========
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: true,
              validator: (value) => FormValidators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 100),

            //===================== btn ====================
            RegisterBtn(onPressed: btnOnPressed, isLoading: _isLoading),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('successful')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
