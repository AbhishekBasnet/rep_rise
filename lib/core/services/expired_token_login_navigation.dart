import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void logoutAndRedirect() {
    // This clears the navigation stack and sends user to login
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}