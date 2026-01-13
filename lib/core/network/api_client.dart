import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/services/expired_token_login_navigation.dart';
import '../services/token_service.dart';
import '../exception/api_exception.dart';

class ApiClient {
  static const String baseApiUrl = "http://10.0.2.2:8000/api/v1/";
  final Dio _dio;
  final TokenService _tokenService;

  ApiClient(this._tokenService)
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ),
  ) {
    // QueuedInterceptorsWrapper lae api req pause garcha, if 401 if returned back from backend
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final bool requiresAuth = options.extra['requiresAuth'] ?? true;
          if (requiresAuth) {
            final token = await _tokenService.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final bool isLogout =
              e.requestOptions.extra['isLogoutRequest'] ?? false;

          if (e.response?.statusCode == 401 &&
              e.requestOptions.extra['requiresAuth'] != false &&
              !isLogout) {

            debugPrint('--- 401 Detected. Attempting Refresh ---');

            final refreshToken = await _tokenService.getRefreshToken();

            if (refreshToken != null) {
              try {
                // Create a new Dio instance to avoid interceptor loops
                final refreshDio = Dio(BaseOptions(baseUrl: baseApiUrl));

                final response = await refreshDio.post('auth/token/refresh/',
                    data: {'refresh': refreshToken});

                // --- SAFETY CHECKS START ---
                final newAccess = response.data['access'];

                // Check if backend rotated the refresh token. If null, keep the old one.
                final newRefresh = response.data['refresh'] ?? refreshToken;

                // Check if backend returned user_id. If null, retrieve the known one from storage.
                String? userId = response.data['user_id'] ?? await _tokenService.getUserId();
                // --- SAFETY CHECKS END ---

                await _tokenService.saveTokens(
                    access: newAccess, refresh: newRefresh, userId: userId!);

                debugPrint('--- Token Refreshed. Retrying original request ---');

                // Update the header with the new token
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';

                // Retry the request
                final clonedRequest = await _dio.fetch(e.requestOptions);
                return handler.resolve(clonedRequest);

              } catch (refreshError) {
                // Refresh failed (token likely explicitly revoked or expired)
                debugPrint('--- Refresh Failed: $refreshError ---');
                await _tokenService.clearTokens();
                NavigationService.logoutAndRedirect();
                return handler.reject(e);
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  }  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final data = e.response?.data;
    String message = "    An unexpected network error occurred.";
    String? code;

    if (data is Map) {
      message = data['detail'] ?? data['message'] ?? message;
      code = data['code'];
    }

    return ApiException(message: message, code: code, statusCode: e.response?.statusCode, fullData: data);
  }
}
