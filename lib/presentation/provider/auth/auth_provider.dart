import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/profile/register_user_profile_data_entity.dart';
import 'package:rep_rise/domain/entity/auth/user_registration_entity.dart';
import 'package:rep_rise/domain/usecase/auth/check_user_name_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/login_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/logout_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/register_usecase.dart';
import 'package:rep_rise/domain/usecase/profile/create_profile_usecase.dart';
import '../../../domain/usecase/auth/check_auth_status_usecase.dart';

/*
 * Centralizes authentication state management and bridges the Presentation layer
 * with Auth/Profile Domain UseCases.
 *
 * Architecture & Responsibilities:
 * --------------------------------
 * 1. Session Management:
 * - Tracks `_isAuthenticated` and `_isInitialized` to guide the `RootWrapper`
 * in making routing decisions (Splash -> Login vs. Home).
 * - Handles forced logouts via `handleExpiredToken` when API calls return 401s.
 *
 * 2. Composite Transactions:
 * - The `registerAndSetupProfile` method orchestrates a complex flow: ensuring
 * a user is registered *and* their profile data is seeded in the remote DB
 * before granting access to the app.
 *
 * 3. Error Sanitation:
 * - Catches raw Domain/Data exceptions and sanitizes the messages (removing
 * prefixes) for consumption by the UI layer.
 */

class AuthProvider extends ChangeNotifier {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckUsernameUseCase checkUsernameUseCase;
  final CreateProfileUseCase createProfileUseCase;

  AuthProvider({
    required this.checkAuthStatusUseCase,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkUsernameUseCase,
    required this.createProfileUseCase,
  }) {
    checkAuthStatus();
  }

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;

  /// for root wrapper, don't delete
  Future<void> checkAuthStatus() async {
    _isAuthenticated = await checkAuthStatusUseCase.execute();
    debugPrint('    --- AUTH STATUS CHECK on auth provider while reloading ---');
    debugPrint('    isAuthenticated: $_isAuthenticated');
    debugPrint('    --- END AUTH STATUS CHECK ---');

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await loginUseCase.execute(username, password);
      _isAuthenticated = success;
      notifyListeners();
      return true;
    } catch (e) {
      _isAuthenticated = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> logout() async {
    _setLoading(true);
    try {
      await logoutUseCase.execute();
      _isAuthenticated = false;
      _clearError();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkUsername(String username) async {
    _setLoading(true);
    _clearError();
    try {
      final isAvailable = await checkUsernameUseCase.execute(username);

      if (!isAvailable) {
        _errorMessage = "This username is already taken";
      }

      return isAvailable;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Orchestrates the multi-step user onboarding flow: Registration followed
  /// immediately by Profile Creation.
  ///
  /// This ensures atomic-like behavior from the user's perspective: they are
  /// not considered "logged in" until both the Auth Account and User Profile are successfully created.
  Future<bool> registerAndSetupProfile({
    required UserRegistrationEntity user,
    required RegisterUserProfileEntity profile,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      debugPrint('    Step 1: Registering & Auto-logging in...');
      await registerUseCase.execute(user);

      debugPrint('    Step 2: Creating profile...');
      await createProfileUseCase.execute(profile);

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isAuthenticated = false;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Forcefully resets authentication state upon token expiration detection.
  ///
  /// This is typically called by an interceptor or service when a 401 Unauthorized
  /// response is received. It triggers a rebuild in `RootWrapper` to redirect to Login.
  /// It also attempts to wipe local data to ensure security.
  Future<void> handleExpiredToken() async {
    try {
      await logoutUseCase.execute();
    } catch (e) {
      debugPrint("Error wiping data during token expiry: $e");
    }

    _isAuthenticated = false;
    _errorMessage = "Session expired. Please login again.";
    notifyListeners();
  }
}
