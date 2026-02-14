import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/create_profile_screen.dart';

import '../../../domain/entity/authentication/user_registration_entity.dart';
import '../../provider/authentication/auth_provider.dart';

class RegisterNewUserScreen extends StatefulWidget {
  const RegisterNewUserScreen({super.key});

  @override
  State<RegisterNewUserScreen> createState() => _RegisterNewUserScreenState();
}

class _RegisterNewUserScreenState extends State<RegisterNewUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordValid = false;
  bool _hasPasswordStarted = false;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordFocused = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final FocusNode _usernameFocusNode = FocusNode();
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  String? _usernameError;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(_onUsernameFocusChange);

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
      if (_passwordFocusNode.hasFocus) {
        _toggleOverlay(true);
      } else {
        _toggleOverlay(false);
      }
    });

    _passwordController.addListener(() {
      final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*?[!@#\$&*~]).{7,}$');
      final bool currentlyValid = regex.hasMatch(_passwordController.text);

      setState(() {
        _isPasswordValid = currentlyValid;
        if (_passwordController.text.isNotEmpty) _hasPasswordStarted = true;
      });

      if (_isPasswordFocused) {
        if (_isPasswordValid) {
          _toggleOverlay(false);
        } else {
          _toggleOverlay(true);
        }
      }
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.removeListener(_onUsernameFocusChange);
    _usernameFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _passwordFocusNode.dispose();
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
      } catch (e) {
        _usernameError = e.toString();
      }
    }
  }

  void _handleNextStep() {
    if (_isUsernameAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fix the username errors first')));
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
      MaterialPageRoute(builder: (context) => CreateProfileScreen(userRegistrationData: incompleteUser)),
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
                Column(
                  children: [
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                        validator: (value) => _isPasswordValid ? null : 'Weak password',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon:
                        (_confirmPasswordController.text.isNotEmpty &&
                            _confirmPasswordController.text == _passwordController.text)
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please confirm your password';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                ElevatedButton(onPressed: _handleNextStep, child: const Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -60),
          child: Material(
            color: Colors.transparent,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isPasswordValid ? 0 : 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  border: Border.all(color: _isPasswordValid ? Colors.green : Colors.red),
                ),
                child: Text(
                  'Must be 7+ chars with Uppercase, Lowercase, and Symbol',
                  style: TextStyle(color: _isPasswordValid ? Colors.green : Colors.red, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleOverlay(bool show) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (show && !_isPasswordValid) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }
}
