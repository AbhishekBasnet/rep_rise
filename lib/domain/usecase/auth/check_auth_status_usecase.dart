import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/services/token_service.dart';
import '../../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final TokenService tokenService;
  final AuthRepository authRepository;

  CheckAuthStatusUseCase({required this.tokenService, required this.authRepository});

  /// Returns true if the user is authenticated, false otherwise.
  Future<bool> execute() async {
    final accessToken = await tokenService.getAccessToken();
    final refreshToken = await tokenService.getRefreshToken();
    debugPrint('    before checking token null on restart');
    debugPrint('    Access Token: \n$accessToken');
    debugPrint('    Refresh Token: \n$refreshToken');
    if (accessToken == null || refreshToken == null) {
      debugPrint('No tokens found. User needs to login.');
      return false;
    }

    bool isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);
    if (isRefreshTokenExpired) {
      debugPrint('Refresh token expired. Redirecting to login.');
      return false;
    }

    bool isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
    if (isAccessTokenExpired) {
      try {
        debugPrint('Access token expired. Attempting refresh...');
        await authRepository.refreshToken(refreshToken);
        return true;
      } catch (e) {
        debugPrint('Token refresh failed: $e');
        return false;
      }
    }
    debugPrint('Both tokens are valid. Authenticated!');
    return true;
  }
}
