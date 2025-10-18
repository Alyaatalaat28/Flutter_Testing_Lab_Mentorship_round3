import 'package:flutter/material.dart';

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

  // ISSUE RESOLVED: Email validation only checked for '@' character
  // This accepted invalid emails like "@", "a@", "@b.com", "test@", etc.
  // FIX: Implement proper email validation using regex pattern
  // WHY: Regex ensures proper email structure (username@domain.extension)
  // Pattern validates:
  // - At least one alphanumeric/special char before @
  // - At least one alphanumeric/special char for domain name
  // - A dot (.) followed by at least 2 letters for top-level domain (TLD)
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // ISSUE RESOLVED: Password validation always returned true
  // This accepted any password including empty, "a", "123", etc.
  // FIX: Implement strong password validation with multiple security checks
  // WHY: Strong passwords protect user accounts from unauthorized access
  // Requirements enforced:
  // - Minimum 8 characters length (industry standard)
  // - At least one number (0-9) for complexity
  // - At least one special character (!@#$%^&*(),.?":{}|<>) for added security
  // - At least one letter (a-z, A-Z) for variety
  bool isValidPassword(String password) {
    if (password.length < 8) {
      return false; // Too short
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return false;
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false;
    }

    // Check for at least one letter (uppercase or lowercase)
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
      return false;
    }

    return true; // All requirements met
  }

  // ISSUE RESOLVED: Form submitted without validation
  // This allowed invalid data to be submitted (empty fields, invalid email, weak password)
  // FIX: Add form validation check before processing submission
  // WHY: Form validation prevents invalid data from being sent to the backend
  // This provides immediate user feedback and reduces server load
  Future<void> _submitForm() async {
    // Validate all form fields before submission
    if (!_formKey.currentState!.validate()) {
      // If validation fails, don't proceed with submission
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // ISSUE RESOLVED: No error handling for failed submissions
    // FIX: Added try-catch block for error handling (currently simulating success)
    // WHY: Real API calls can fail due to network issues, server errors, etc.
    // In production, this would handle actual API errors
    try {
      // In production, this would be an actual API call
      // For now, we simulate success
      setState(() {
        _isLoading = false;
        _message = 'Registration successful!';
      });
    } catch (e) {
      // Handle registration errors
      setState(() {
        _isLoading = false;
        _message = 'Registration failed. Please try again.';
      });
    }
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!isValidEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                helperText: 'At least 8 characters with numbers and symbols',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (!isValidPassword(value)) {
                  return 'Password is too weak';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator()
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
