import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_client.dart';
import '../../core/exception/api_exception.dart';
import '../../core/services/token_service.dart';
import '../../domain/entity/user_registration_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final TokenService tokenService;

  AuthRepositoryImpl(this.apiClient, this.tokenService);

  @override
  Future<void> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        'auth/login/',
        data: {'username': username, 'password': password},
        options: Options(extra: {'requiresAuth': false}),
      );

      debugPrint('    --- LOGIN SUCCESS ---');
      debugPrint(response.data.toString());

      await tokenService.saveTokens(
        access: response.data['access'],
        refresh: response.data['refresh'],
        userId: response.data['user_id'].toString(),
      );

      debugPrint('    --- LOGIN Successful (Frontend Response) ---');
      debugPrint('    \nUser Id: ${response.data['user_id']}');
      debugPrint('    Access Token: \n${response.data['access']}');
      debugPrint('    Refresh Token: \n${response.data['refresh']}');
    } on DioException catch (e) {
      debugPrint('    --- LOGIN ERROR (Backend Response) ---');
      if (e.response != null) {
        debugPrint(e.response?.data.toString());

        throw Exception(e.response?.data['detail'] ?? "   Login failed");
      } else {
        debugPrint('    Connection Error: ${e.message}');
        throw Exception("   Could not connect to server");
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await tokenService.getRefreshToken();
      if (refreshToken != null) {
        await apiClient.post(
          'auth/logout/',
          data: {'refresh': refreshToken},
          options: Options(extra: {'requiresAuth': false, 'isLogoutRequest': true}),
        );
      }
    } catch (e) {
      debugPrint('Server logout failed, but we will clear local data anyway.');
    } finally {
      await tokenService.clearTokens();
    }
  }

  @override
  Future<void> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        'auth/token/refresh/',
        data: {'refresh': refreshToken},
        options: Options(extra: {'requiresAuth': false}),
      );

      if (response.statusCode == 200) {
        final String newAccessToken = response.data['access'];
        final String currentRefresh = response.data['refresh'] ?? refreshToken;
        final String? currentUserId = response.data['user_id']?.toString() ?? await tokenService.getUserId();

        await tokenService.saveTokens(access: newAccessToken, refresh: currentRefresh, userId: currentUserId ?? '');
        debugPrint('    New Access Token: $newAccessToken');
      }
    } on ApiException catch (e) {
      // NOW YOU HAVE FULL ACCESS!
      debugPrint('--- AUTH REFRESH ERROR (Backend Response) ---');
      debugPrint('Message: ${e.message}');
      debugPrint('Detail: ${e.detail}');
      debugPrint('Code: ${e.code}');
      debugPrint('Status: ${e.statusCode}');

      // You can handle specific backend codes here
      if (e.code == "token_not_valid") {
        await tokenService.clearTokens();
        throw Exception("Session expired: ${e.message}");
      }

      rethrow;
    }
  }

  @override
  Future<void> register(UserRegistrationEntity user) async {
    try {
      final response = await apiClient.post(
        'auth/register/',
        data: {
          'username': user.username,
          'email': user.email,
          'password': user.password
        },
        options: Options(extra: {'requiresAuth': false}),
      );

      debugPrint('    --- REGISTRATION SUCCESS ---');
      debugPrint(response.data.toString());

      await tokenService.saveTokens(
        access: response.data['access'],
        refresh: response.data['refresh'],
        userId: response.data['user_id'].toString(),
      );

      debugPrint('    --- TOKENS SAVED (Auto-Login) ---');

    } on DioException catch (e) {
      final message = e.response?.data['detail'] ?? "Registration failed";
      throw Exception(message);
    }
  }


  @override
  Future<bool> checkUsername(String userName) async {
    try {
      final response = await apiClient.get(
        'auth/check-username/',
        queryParameters: {'username': userName},
        options: Options(extra: {'requiresAuth': false}),
      );

      if (response.data != null && response.data['available'] is bool) {
        return response.data['available'];
      }
      return false;

    } on DioException catch (e) {
      final message = e.response?.data['detail'] ?? "Error checking username";
      throw Exception(message);
    }
  }


}
