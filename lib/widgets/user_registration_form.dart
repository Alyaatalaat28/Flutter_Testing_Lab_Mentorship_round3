import 'package:flutter/material.dart';

class ValidationService {
  String? validateName(String? name) {
    if (name == null || name.isEmpty) return 'Full name is required';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name should contain only letters and spaces';
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(
      r'^[a-zA-Z][a-zA-Z._%+-]*@[a-zA-Z.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      return 'Invalid email format (only letters allowed in local part)';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@#$%^&+=]).{8,}$',
    ).hasMatch(password)) {
      return 'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.';
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}

class UserRegistrationForm extends StatefulWidget {
  final Future<void> Function()? onSubmit; // For testing
  const UserRegistrationForm({super.key, this.onSubmit});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _validationService = ValidationService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Please correct the errors in the form.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!();
      } else {
        await Future.delayed(const Duration(seconds: 2));
      }

      setState(() => _isLoading = false);

      // ✅ Show success message in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Registration successful!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3), // stays visible for screenshots
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validationService.validateName,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validationService.validateEmail,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                helperText: 'Min 8 chars, incl. A-Z, a-z, 0-9, and symbols',
              ),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validationService.validatePassword,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => _validationService.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Text('Register'),
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
