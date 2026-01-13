import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/auth_provider.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void logoutAndRedirect() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login_screen', (route) => false);
  }
}