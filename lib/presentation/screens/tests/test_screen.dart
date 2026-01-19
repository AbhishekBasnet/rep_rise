import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rep_rise/core/di/injection_container.dart.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';
import 'package:rep_rise/presentation/provider/auth_provider.dart';
import 'package:rep_rise/presentation/screens/auth/register_new_user_screen.dart';
import 'package:rep_rise/presentation/screens/tests/font_test_screen.dart';
import 'package:rep_rise/presentation/screens/tests/step_api_test_screen.api.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _isProcessing = false;

  void _handleLogout() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) setState(() => _isProcessing = false);
  }

  void _testFont() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FontTestScreen()));
  }

  void _testRegistration() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterNewUserScreen()));
  }

  void _testStepsApi() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StepApiTestScreen(repository: sl<StepRepository>())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: authProvider.isLoading ? null : _handleLogout,
              child: authProvider.isLoading ? CircularProgressIndicator() : Text('Logout'),
            ),
            ElevatedButton(onPressed: _testFont, child: Text('Test Fonts')),
            ElevatedButton(onPressed: _testRegistration, child: Text('Test Registration')),
            ElevatedButton(onPressed: _testStepsApi, child: Text('Test Steps API')),
          ],
        ),
      ),
    );
  }
}
