import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';

  void _handleLogin() {
    setState(() => _error = '');
    
    final success = context.read<AppState>().login(
      _identifierController.text,
      _passwordController.text,
    );

    if (success) {
      if (context.read<AppState>().isStaff) {
        Navigator.of(context).pushReplacementNamed('/staff-dashboard');
      } else {
        Navigator.of(context).pushReplacementNamed('/location');
      }
    } else {
      setState(() => _error = 'User not found or incorrect password');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Icons.login,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome to Cafe Click',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFE6E1E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFCAC4D0),
                  ),
                ),
                const SizedBox(height: 32),

                // Login Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email / Matric No / Staff No',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFCAC4D0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _identifierController,
                      decoration: const InputDecoration(
                        hintText: 'student@iium.edu.my or 2012345',
                      ),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFCAC4D0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                      ),
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

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: 16),

                // Register Link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text(
                    "Don't have an account? Register here",
                    style: TextStyle(color: Color(0xFFD0BCFF)),
                  ),
                ),

                const SizedBox(height: 32),

                // Demo Credentials
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2930),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Credentials:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFCAC4D0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Customer: student / 123',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF938F99),
                        ),
                      ),
                      Text(
                        'Staff: staff / 123',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF938F99),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
