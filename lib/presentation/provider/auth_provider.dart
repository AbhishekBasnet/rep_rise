import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/user_registration_entity.dart';
import '../../data/model/user_registration_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  // --- State Variables ---
  bool _isLoading = false;
  String? _errorMessage;

  // --- Getters ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- Actions ---

  /// Handles user login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await authRepository.login(username, password);
      _setLoading(false);
      return true; // Success
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false; // Failure
    }
  }

  /// Handles user registration
  Future<bool> register(UserRegistrationEntity newUser) async {
    _setLoading(true);
    _clearError();

    try {
      await authRepository.register(newUser);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  /// Handles user logout
  Future<void> logout(String refreshToken) async {
    _setLoading(true);
    try {
      await authRepository.logout(refreshToken);
    } catch (e) {
      _errorMessage = "Logout failed";
    } finally {
      _setLoading(false);
    }
  }

  // --- Helpers ---
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // This triggers the UI to rebuild
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}