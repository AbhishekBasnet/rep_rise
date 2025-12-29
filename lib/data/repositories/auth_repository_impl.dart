import 'package:dio/dio.dart';
import 'package:rep_rise/data/model/user_registration_model.dart';

import '../../core/network/api_client.dart';
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

      await tokenService.saveTokens(access: response.data['access'], refresh: response.data['refresh'],userId: response.data['user_id']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Login failed");
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
        final authData = AuthResponseModel.fromJson(response.data);
        await tokenService.saveTokens(
            access: authData.access,
            refresh: authData.refresh,
            userId: authData.userId,
        );
      }
    } on DioException catch (e) {
      await tokenService.clearTokens();
      throw Exception("Session expired. Please login again. ${e.response?.data['detail']}");
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
