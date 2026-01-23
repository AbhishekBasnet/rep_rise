import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/services/expired_token_login_navigation.dart';
import '../services/token_service.dart';
import '../exception/api_exception.dart';

/*
     * -------------------------------------------------------------------------
     * Authentication & Token Refresh Flow
     * -------------------------------------------------------------------------
     *
     * This interceptor manages the JWT authentication lifecycle:
     *
     * 1. Request Interception:
     * - Checks if the request requires authentication via [options.extra].
     * - Injects the 'Authorization: Bearer <token>' header if a valid
     * access token exists in [TokenService].
     *
     * 2. Error Interception (401 Unauthorized):
     * - If the backend returns a 401, the [QueuedInterceptorsWrapper] locks
     * the request queue to prevent race conditions (multiple concurrent refresh attempts).
     *
     * 3. Token Rotation Logic:
     * - Retrieves the refresh token from secure storage.
     * - Creates a *temporary* Dio instance to call the refresh endpoint.
     * (Note: Using the main _dio instance here would trigger a circular interceptor loop).
     * - If successful:
     * a. Updates the [TokenService] with the new Access/Refresh tokens.
     * b. Updates the header of the original failed request.
     * c. Retries the original request transparently.
     *
     * 4. Failure Handling:
     * - If the refresh token is expired, invalid, or revoked:
     * a. Clears local storage.
     * b. Forces a user logout via [NavigationService].
     */

/// A network client wrapper around [Dio] that handles HTTP requests,
/// authentication, and error transformation.
///

/// * managing the base configuration (timeouts, headers).
/// * injecting authentication tokens into requests.
/// * automatically refreshing expired tokens (401 handling).
/// * normalizing [DioException]s into domain-specific [ApiException]s.
///
/// Usage:
/// ```dart
/// final response = await apiClient.get('/endpoint');
/// ```
class ApiClient {
  // static const String baseApiUrl = "http://127.0.0.1:8000/api/v1/";
  static const String baseApiUrl = "http://10.0.2.2:8000/api/v1/";
  final Dio _dio;
  final TokenService _tokenService;

  ApiClient(this._tokenService)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseApiUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
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
          final bool isLogout = e.requestOptions.extra['isLogoutRequest'] ?? false;

          if (e.response?.statusCode == 401 && e.requestOptions.extra['requiresAuth'] != false && !isLogout) {
            debugPrint('--- 401 Detected. Attempting Refresh ---');

            final refreshToken = await _tokenService.getRefreshToken();

            if (refreshToken != null) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: baseApiUrl));

                final response = await refreshDio.post('auth/token/refresh/', data: {'refresh': refreshToken});

                final newAccess = response.data['access'];

                final newRefresh = response.data['refresh'] ?? refreshToken;

                String? userId = response.data['user_id'] ?? await _tokenService.getUserId();

                await _tokenService.saveTokens(access: newAccess, refresh: newRefresh, userId: userId!);

                debugPrint('--- Token Refreshed. Retrying original request ---');

                e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';

                final clonedRequest = await _dio.fetch(e.requestOptions);
                return handler.resolve(clonedRequest);
              } catch (refreshError) {
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
  }

  /// Performs an HTTP POST request.
  ///
  /// [path] is the endpoint path (relative to the base URL).
  /// [data] contains the body of the request (automatically JSON encoded).
  /// [queryParameters] are appended to the URL.
  /// [options] allow overriding headers or auth requirements (e.g., `requiresAuth: false`).
  ///
  /// Throws an [ApiException] if the request fails or returns a non-200 status.
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Performs an HTTP GET request.
  ///
  /// [path] is the endpoint path (relative to the base URL).
  /// [queryParameters] are mapped to URL query strings.
  ///
  /// Returns a [Response] object containing the backend data.
  /// Throws an [ApiException] on failure.
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Performs an HTTP PATCH request for partial updates.
  ///
  /// [path] is the endpoint path.
  /// [data] contains the fields to be updated.
  ///
  /// Throws an [ApiException] on failure.
  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Parses [DioException] and converts it into a standardized [ApiException].
  ///
  /// This method extracts error messages from the backend response structure
  /// (handling 'detail', 'message', or 'code' fields) to provide a
  /// user-friendly error description.
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
