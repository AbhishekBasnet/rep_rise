// lib/root_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/screens/profile/profile/create_profile/create_profile_screen.dart';

import '../provider/auth_provider.dart';
import 'auth/login_screen.dart';
import 'main_screen.dart';


class RootWrapper extends StatelessWidget {
  const RootWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.isAuthenticated) {
      // return const MainScreen();
      return const CreateProfileScreen();
    } else {
      return const LoginScreen();
    }
  }
}
