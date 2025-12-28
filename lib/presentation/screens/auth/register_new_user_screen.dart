import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/user_registration_entity.dart';
import '../../provider/auth_provider.dart';

class RegisterNewUserScreen extends StatefulWidget {
  const RegisterNewUserScreen({super.key});

  @override
  State<RegisterNewUserScreen> createState() => _RegisterNewUserScreenState();
}

class _RegisterNewUserScreenState extends State<RegisterNewUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newUser = UserRegistrationEntity(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    final success = await authProvider.register(newUser);
    if (mounted) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage ?? 'Registration Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 16),
                Text('Enter your details to register new account', style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter Username' : null,
                  decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter E-mail' : null,
                  decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter password' : null,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                ElevatedButton(onPressed: _handleRegister, child: const Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
