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

    if (accessToken != null && refreshToken != null) {
      bool isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
      bool isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);

      if (isRefreshTokenExpired) {
        debugPrint('    --- AUTH DEBUG START (in check auth UseCase)---');
        debugPrint('    TOKEN STATUS: Refresh token Expired! Redirecting to Login.');
        debugPrint('    Access Token: \n$accessToken');
        debugPrint('    Refresh Token: \n$refreshToken');
        debugPrint('    --- AUTH DEBUG END ---');
        return false;
      }
      if (isAccessTokenExpired) {
        debugPrint('    --- AUTH DEBUG START (in check auth UseCase)---');
        debugPrint('    TOKEN STATUS: Access token Expired! Redirecting to Login.');
        debugPrint('    Using Refresh Token to get new access token. RefreshToken: \n$refreshToken');
        debugPrint('    Old Access Token: $accessToken');
        try {
          await authRepository.refreshToken(refreshToken);
          debugPrint('    --- AUTH DEBUG END ---');
          return true;
        } catch (e) {
          debugPrint('    Failed to refresh token: $e');
          debugPrint('    --- AUTH DEBUG END ---');
          return false;
        }
      }
    }
    return false;
  }
}