import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/registration_form/widgets/form_validators.dart';

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

  Future<void> _submitForm() async {
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                FormValidators.validateName(value);
                return null;
              },
            ),
            const SizedBox(height: 16),

            //======================= email ====================
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                FormValidators.validateEmail(value);
                return null;
              },
            ),
            const SizedBox(height: 16),

            //======================= password ================
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                helperText: 'At least 8 characters with numbers and symbols',
              ),
              obscureText: true,
              validator: (password) {
                FormValidators.validatePassword(password);
                return null;
              },
            ),
            const SizedBox(height: 16),

            //======================= comfirmPassword ===========
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                FormValidators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                );
                return null;
              },
            ),
            const SizedBox(height: 24),

            //===================== btn ====================
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                }
              },
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const CircularProgressIndicator(),
                    )
                  : const Text('Register'),
            ),
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
