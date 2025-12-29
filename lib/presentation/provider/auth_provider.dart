import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/user_registration_entity.dart';
import 'package:rep_rise/domain/usecase/auth/login_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/logout_usecase.dart';
import 'package:rep_rise/domain/usecase/auth/register_usecase.dart';
import '../../domain/usecase/auth/check_auth_status_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthProvider({
    required this.checkAuthStatusUseCase,
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase
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
  bool get isInitialized => _isInitialized; /// for root wrapper, don't delete

  // --- Actions ---

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await checkAuthStatusUseCase.execute();

    _isInitialized = true;
    notifyListeners();
  }

  /// Handles user login
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

  /// Handles user registration
  Future<bool> register(UserRegistrationEntity newUser) async {
    _setLoading(true);
    _clearError();

    try {
      await registerUseCase.execute(newUser);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }


  /// Handles user logout
  Future<void> logout(String refreshToken) async {
    _setLoading(true);
    try {

      await logoutUseCase.execute(refreshToken);
      _isAuthenticated = false;
      _clearError();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
  // --- Helpers ---
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
