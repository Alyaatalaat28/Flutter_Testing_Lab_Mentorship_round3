// lib/widgets/user_registration_form.dart
import 'package:flutter/material.dart';
import '../utils/validators.dart';

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
    // Validate first (synchronous)
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      // focus first invalid field could be added here
      setState(() {
        _message = 'Please fix the errors in the form';
      });
      return;
    }

    // Clear any previous message and start loading only after validation passes
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // On success
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _message = 'Registration successful!';
      });

      // Optionally reset the form or navigate
      // _formKey.currentState?.reset();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _message = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.nameValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  helperText: 'At least 8 characters, number, special char, uppercase',
                ),
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: Validators.passwordValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Register'),
                ),
              ),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('successful') ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
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
