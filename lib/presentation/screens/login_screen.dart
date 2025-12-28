import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/main_screen.dart';

import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Inside _LoginScreenState class
  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Access logic

    // Get values from controllers
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    // Call the login method from AuthProvider
    final success = await authProvider.login(username, password);

    if (mounted) {
      if (success) {
        // Navigate to MainScreen upon success
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Show error message from provider
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage ?? "Login Failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // We "watch" the provider here to rebuild when isLoading changes
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              // Dynamic Button State
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _handleLogin, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
