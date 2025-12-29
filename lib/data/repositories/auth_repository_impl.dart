import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rep_rise/data/model/user_registration_model.dart';

import '../../core/network/api_client.dart';
import '../../core/exception/api_exception.dart';
import '../../core/services/token_service.dart';
import '../../domain/entity/user_registration_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../model/auth_model.dart';

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
  Future<void> logout(String refreshToken) async {
    try {
      await apiClient.post(
        'auth/logout/',
        data: {'refresh': refreshToken},
        options: Options(extra: {'requiresAuth': false}),
      );
    } on DioException catch (e) {
      throw Exception(e.response);
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
      await apiClient.post(
        'auth/register/',
        data: {'username': user.username, 'email': user.email, 'password': user.password},
        options: Options(extra: {'requiresAuth': false}),
      );
    } on DioException catch (e) {
      final message = e.response?.data['detail'] ?? "Registration failed";
      throw Exception(message);
    }
  }
}
