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
      final response = await apiClient.dio.post('auth/login/', data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        final authData = AuthResponseModel.fromJson(response.data);

        // The next API call will trigger the Interceptor, which reads this token.
        await tokenService.saveTokens(access: authData.access, refresh: authData.refresh);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Login failed");
    }
  }


  @override
  Future<void> logout(String refreshToken) async {
    try {
      await apiClient.dio.post('auth/logout/', data: {'refresh': refreshToken});
    } on DioException catch (e) {
      throw Exception(e.response);
    } finally {
      await tokenService.clearTokens();
    }
  }

  @override
  Future<void> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.dio.post('auth/token/refresh/', data: {'refresh': refreshToken});
      if (response.statusCode == 200) {
        final authData = AuthResponseModel.fromJson(response.data);

        // Save the new tokens. The Interceptor will automatically pick them up.
        await tokenService.saveTokens(access: authData.access, refresh: authData.refresh);
      }
    } on DioException catch (e) {
      await tokenService.clearTokens();
      throw Exception("Session expired. Please login again. Error: ${e.response?.data['detail'] ?? e.message}");
    }
  }




  @override
  Future<void> register(UserRegistrationEntity newUser) async { // Accepts Entity
    try {
      // 1. Convert Entity to Model so we can use .toJson()
      final userModel = UserRegistrationModel(
        username: newUser.username,
        email: newUser.email,
        password: newUser.password,
        height: newUser.height,
        weight: newUser.weight,
        birthDate: newUser.birthDate,
        activityLevel: newUser.activityLevel,
        fitnessGoal: newUser.fitnessGoal,
      );

      // 2. Send the JSON to the backend
      final response = await apiClient.dio.post(
        'auth/register/',
        data: userModel.toJson(), // The model handles the JSON structure
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final authData = AuthResponseModel.fromJson(response.data);
        await tokenService.saveTokens(
          access: authData.access,
          refresh: authData.refresh,
        );
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['detail'] ??
          e.response?.data['message'] ??
          "Registration failed";
      throw Exception(errorMessage);
    }
  }


}
