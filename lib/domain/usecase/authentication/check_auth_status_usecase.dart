import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/services/token_service.dart';
import '../../../core/util/extension/jwt_decoder.dart';
import '../../repositories/authentication/auth_repository.dart';

class CheckAuthStatusUseCase {
  final TokenService tokenService;
  final AuthRepository authRepository;

  CheckAuthStatusUseCase({required this.tokenService, required this.authRepository});

  Future<bool> execute() async {
    final accessToken = await tokenService.getAccessToken();
    final refreshToken = await tokenService.getRefreshToken();

    debugPrint('    --- Auth Status Check ---');

    if (accessToken == null || refreshToken == null) {
      debugPrint('    Status: No tokens found. User needs to login.');
      return false;
    }

    debugPrint('    Access Token Status: ${accessToken.expirationStatus}');
    debugPrint('    Refresh Token Status: ${refreshToken.expirationStatus}');
    debugPrint('    Access Token : $accessToken');
    debugPrint('    Refresh Token : $refreshToken');

    bool isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);
    if (isRefreshTokenExpired) {
      debugPrint('    Refresh Token Expired: ${refreshToken.expirationStatus}');
      debugPrint('    Status: Refresh token expired. Redirecting to login.');
      return false;
    }

    bool isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
    if (isAccessTokenExpired) {
      try {
        debugPrint('    Access Token Expired on: ${accessToken.expirationStatus}');
        debugPrint('    Refresh Token Status: ${refreshToken.expirationStatus}');
        debugPrint('    Status: Access token expired. Attempting refresh...');
        await authRepository.refreshToken(refreshToken);

        final newAccessToken = await tokenService.getAccessToken();
        debugPrint('    New Access Token Status: ${newAccessToken?.expirationStatus}');

        return true;
      } catch (e) {
        debugPrint('    Status: Token refresh failed: $e');
        return false;
      }
    }

    debugPrint('    Status: Both tokens are valid. Authenticated!');
    return true;
  }
}