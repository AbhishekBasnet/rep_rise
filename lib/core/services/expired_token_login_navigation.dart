import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void logoutAndRedirect() {
    debugPrint('    --- on expired token navigation service check---');
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}