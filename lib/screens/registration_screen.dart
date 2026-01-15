import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _matricController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _error = '';
  bool _success = false;

  void _handleRegister() {
    setState(() => _error = '');

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _matricController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _error = 'All fields are required');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 3) {
      setState(() => _error = 'Password must be at least 3 characters');
      return;
    }

    // Mock Registration Success
    setState(() => _success = true);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // Back to login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFA8DAB5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: Color(0xFF1F3823),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Registration Successful!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFE6E1E5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Redirecting to login...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFCAC4D0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Header
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6750A4), Color(0xFFD0BCFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFE6E1E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join Cafe Click today',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFCAC4D0),
                  ),
                ),
                const SizedBox(height: 32),

                // Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Full Name *'),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'Ahmad bin Abdullah'),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel(context, 'Email *'),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'student@iium.edu.my'),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel(context, 'Matric / Staff Number *'),
                    TextField(
                      controller: _matricController,
                      decoration: const InputDecoration(hintText: '2012345 or STF001'),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel(context, 'Password *'),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Minimum 3 characters'),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel(context, 'Confirm Password *'),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Re-enter password'),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                  ],
                ),

                // Error Message
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF601410),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error,
                      style: const TextStyle(color: Color(0xFFF2B8B5)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    child: const Text('Create Account'),
                  ),
                ),

                const SizedBox(height: 16),

                // Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Already have an account? Sign in",
                    style: TextStyle(color: Color(0xFFD0BCFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFFCAC4D0),
        ),
      ),
    );
  }
}
