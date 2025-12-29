import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void logoutAndRedirect() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}