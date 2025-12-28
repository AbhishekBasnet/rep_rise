import 'package:dio/dio.dart';
import 'package:rep_rise/domain/entity/user_registration_entity.dart';

import '../../core/network/api_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../model/auth_model.dart';


class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<void> login(String username, String password) async {
    try {
      final response = await apiClient.dio.post('auth/login/', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final authData = AuthResponseModel.fromJson(response.data);
        apiClient.setToken(authData.access);
        // TODO: Save tokens to Secure Storage
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Login failed");
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    await apiClient.dio.post('auth/logout/', data: {'refresh': refreshToken});
  }

  @override
  Future<void> register(UserRegistrationEntity newUser) async {
    await apiClient.dio.post('auth/register/', data: newUser);
  }

  @override
  Future<void> refreshToken(String refreshToken) async {
    final response = await apiClient.dio.post(
        'auth/refresh/', data: {'refresh': refreshToken}); //TODO: Implement token refresh logic on local storage
  }
}