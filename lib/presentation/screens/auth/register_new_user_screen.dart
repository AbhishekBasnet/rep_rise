import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/create_profile_screen.dart';

import '../../../domain/entity/auth/user_registration_entity.dart';
import '../../provider/auth/auth_provider.dart';

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

  final FocusNode _usernameFocusNode = FocusNode();
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  String? _usernameError;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(_onUsernameFocusChange);
  }

  @override
  void dispose() {
    _usernameFocusNode.removeListener(_onUsernameFocusChange);
    _usernameFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onUsernameFocusChange() async {
    if (!_usernameFocusNode.hasFocus) {
      final username = _usernameController.text.trim();

      if (username.isEmpty) return;

      setState(() {
        _isCheckingUsername = true;
        _usernameError = null;
        _isUsernameAvailable = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await authProvider.checkUsername(username);


      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
          _isUsernameAvailable = success;
          if (!success) {
            _usernameError = authProvider.errorMessage;
          }
        });
      }
    } catch(e){
      _usernameError = e.toString();
    }

    }
  }

  void _handleNextStep() {
    if (_isUsernameAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the username errors first')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final incompleteUser = UserRegistrationEntity(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProfileScreen(userRegistrationData: incompleteUser),
      ),
    );
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
                  focusNode: _usernameFocusNode,
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter Username' : null,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: _usernameError,
                    border: const OutlineInputBorder(),
                    suffixIcon: _isCheckingUsername
                        ? const CircularProgressIndicator()
                        : _isUsernameAvailable == true
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : _isUsernameAvailable == false
                        ? const Icon(Icons.error, color: Colors.red)
                        : null,
                  ),
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
                ElevatedButton(onPressed: _handleNextStep, child: const Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
