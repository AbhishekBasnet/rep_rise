import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_rise/presentation/provider/auth_provider.dart';

/// A centralized navigation handler that allows navigation from outside the
/// widget tree (e.g., from [ApiClient] or Business Logic Components).
///
/// This service is primarily used to handle forced redirection logic, such as
/// when an authentication token expires and the user must be returned to the
/// login screen immediately, clearing the navigation stack.
class NavigationService {
  /*
   * ARCHITECTURE NOTE:
   * This service solves the "Contextless Navigation" problem.
   *
   * Scenario: The ApiClient receives a 401 error. It is a plain Dart class
   * and does not have access to the Flutter Widget tree or BuildContext.
   *
   * Solution: By exposing a static [navigatorKey], we can lookup the
   * current context and NavigatorState from anywhere in the app to force
   * UI transitions based on network events.
   */

  /// A global key that provides access to the root [NavigatorState].
  ///
  /// This must be assigned to the `navigatorKey` property of your [MaterialApp]
  /// in `main.dart` to function correctly.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Performs a forced logout and redirects the user to the login screen.
  ///
  /// This method:
  /// 1. Accesses the current [AuthProvider] via the global context to sync
  ///    authentication state (setting it to unauthenticated).
  /// 2. Clears the entire navigation stack.
  /// 3. Pushes the `/login_screen` route.
  ///
  /// Usage:
  /// Call this when a 401 Unauthorized error is unrecoverable.
  static void logoutAndRedirect() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login_screen', (route) => false);
  }
}
