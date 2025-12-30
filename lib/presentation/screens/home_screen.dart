import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/profile/font_test_screen.dart';

import '../provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isProcessing = false;

  void _handleLogout() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) setState(() => _isProcessing = false);
  }
  void _testFont() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FontTestScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings Screen')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: authProvider.isLoading ? null : _handleLogout,
              child: authProvider.isLoading ? CircularProgressIndicator() : Text('Logout'),
            ),
            ElevatedButton(onPressed: _testFont, child: Text('Test Fonts')),
          ],
        ),
      ),
    );
  }
}
