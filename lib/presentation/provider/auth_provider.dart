import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rep_rise/domain/entity/user_registration_entity.dart';
import '../../core/services/token_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final TokenService tokenService;

  AuthProvider({required this.authRepository, required this.tokenService}){
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

  // --- Actions ---

  Future<void> checkAuthStatus() async {
    // Fetch tokens from FlutterSecureStorage
    final accessToken = await tokenService.getAccessToken();
    final refreshToken = await tokenService.getRefreshToken();

    if (accessToken != null) {
      bool isExpired = JwtDecoder.isExpired(accessToken);
      if (isExpired) {
        debugPrint('--- AUTH DEBUG START (on Auth Provider)---');
        debugPrint('TOKEN STATUS: Expired! Redirecting to Login.');
        debugPrint('--- Tokens expired ---');
        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: ${refreshToken ?? "NULL"}');
        debugPrint('--- AUTH DEBUG END ---');
        _isAuthenticated = false;
      } else {
        _isAuthenticated = true;

        // Debug Printing
        debugPrint('--- AUTH DEBUG START (on Auth Provider)---');
        debugPrint('--- Tokens arent expired ---');
        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: ${refreshToken ?? "NULL"}');
        debugPrint('--- AUTH DEBUG END ---');
      }
    }



    // Basic check: if access token exists, we assume authenticated for now

    _isAuthenticated = accessToken != null;
    _isInitialized = true;
    notifyListeners();
  }


  /// Handles user login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      await authRepository.login(username, password);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isAuthenticated = false;
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
    await authRepository.logout(refreshToken);
    await tokenService.clearTokens(); // Clear local storage
    _isAuthenticated = false;
    notifyListeners();
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