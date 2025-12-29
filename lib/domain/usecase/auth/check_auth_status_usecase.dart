
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/services/token_service.dart';

class CheckAuthStatusUseCase {
  final TokenService tokenService;

  CheckAuthStatusUseCase({required this.tokenService});

  /// Returns true if the user is authenticated, false otherwise.
  Future<bool> execute() async {
    final accessToken = await tokenService.getAccessToken();
    final refreshToken = await tokenService.getRefreshToken();

    if (accessToken != null) {
      bool isExpired = JwtDecoder.isExpired(accessToken);

      if (isExpired) {
        debugPrint('--- AUTH DEBUG START (in check auth UseCase)---');
        debugPrint('TOKEN STATUS: Expired! Redirecting to Login.');
        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: ${refreshToken ?? "NULL"}');
        debugPrint('--- AUTH DEBUG END ---');
        return false;
      } else {
        debugPrint('--- AUTH DEBUG START (in check auth UseCase)---');
        debugPrint('--- Tokens arent expired ---');
        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: ${refreshToken ?? "NULL"}');
        debugPrint('--- AUTH DEBUG END ---');
        return true;
      }
    }

    // If no access token exists, they are not authenticated
    return false;
  }
}