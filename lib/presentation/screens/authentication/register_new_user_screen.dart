import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/profile/create_profile/create_profile_screen.dart';

import '../../../core/theme/app_theme.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fix the username errors first')));
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
          builder: (context) => CreateProfileScreen(userRegistrationData: incompleteUser)),
    );
  }

  // Helper method for standard Input Decoration
  InputDecoration _buildInputDecoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.primaryPurple),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: AppTheme.secondaryGrey,
      errorText: label == 'Username' ? _usernameError : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView( // Changed to SingleChildScrollView for smaller screens
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Account', style: AppTheme.lightTheme.textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text('Start your journey with Rep Rise', style: AppTheme.profileSetupSubHeader),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.homeActivityCardDecoration.boxShadow,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username
                      TextFormField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        validator: (value) =>
                        (value == null || value.isEmpty) ? 'Enter Username' : null,
                        decoration: _buildInputDecoration(
                          'Username',
                          Icons.person,
                          suffix: _isCheckingUsername
                              ? Transform.scale(scale: 0.5, child: const CircularProgressIndicator())
                              : _isUsernameAvailable == true
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : _isUsernameAvailable == false
                              ? const Icon(Icons.error, color: Colors.red)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        validator: (value) =>
                        (value == null || value.isEmpty) ? 'Enter E-mail' : null,
                        decoration: _buildInputDecoration('E-mail', Icons.email),
                      ),
                      const SizedBox(height: 16),

                      // Password (Target for Overlay)
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          decoration: _buildInputDecoration('Password', Icons.lock),
                          validator: (value) => _isPasswordValid ? null : 'Weak password',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                          'Confirm Password',
                          Icons.lock_clock,
                          suffix: (_confirmPasswordController.text.isNotEmpty &&
                              _confirmPasswordController.text == _passwordController.text)
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please confirm your password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleNextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // Overlay Logic (Styled better)
  // -----------------------------------------------------------------

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    // Calculate offset if needed, but CompositedTransformFollower usually handles it

    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 80, // Dynamic width based on padding
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -70), // Push it up above the field
          child: Material(
            color: Colors.transparent,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isPasswordValid ? 0 : 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C), // Dark tooltip background
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0,4))
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Must be 7+ chars with Uppercase, Lowercase, and Symbol',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
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