import 'package:dio/dio.dart';
import 'package:rep_rise/core/services/expired_token_login_navigation.dart';
import '../services/token_service.dart';

class ApiClient {
  static const String baseApiUrl = "http://10.0.2.2:8000/api/v1/";
  final Dio dio;
  final TokenService _tokenService;

  ApiClient(this._tokenService)
    : dio = Dio(
        BaseOptions(
          baseUrl: baseApiUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      ) {
    // api_client.dart
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final bool requiresAuth = options.extra['requiresAuth'] ?? true;
          if (requiresAuth) {
            final token = await _tokenService.getAccessToken();
            if (token != null) options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // 1. Check if error is 401 and it's not a public endpoint
          if (e.response?.statusCode == 401 && e.requestOptions.extra['requiresAuth'] != false) {
            final refreshToken = await _tokenService.getRefreshToken();

            if (refreshToken != null) {
              try {
                // 2. Call the Refresh logic (using different same Dio instance to prevent loops)
                final refreshDio = Dio(BaseOptions(baseUrl: baseApiUrl));
                final response = await refreshDio.post('auth/token/refresh/', data: {'refresh': refreshToken});

                final newAccess = response.data['access'];
                final newRefresh = response.data['refresh'];

                // 3. Save new tokens
                await _tokenService.saveTokens(access: newAccess, refresh: newRefresh);

                // 4. Retry the original failed request with the new access token
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
                final clonedRequest = await dio.fetch(e.requestOptions);
                return handler.resolve(clonedRequest);
              } catch (refreshError) {
                // If refresh fails (the 24hr token expired), force a logout
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
}
