import 'package:dio/dio.dart';
import 'package:rep_rise/core/services/expired_token_login_navigation.dart';
import '../services/token_service.dart';
import '../exception/api_exception.dart';

class ApiClient {
  static const String baseApiUrl = "http://10.0.2.2:8000/api/v1/";
  final Dio _dio; // private so no one can touch it directly out side api client
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
    _dio.interceptors.add(
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
          final bool isLogout = e.requestOptions.extra['isLogoutRequest'] ?? false;
          if (e.response?.statusCode == 401 && e.requestOptions.extra['requiresAuth'] != false && !isLogout) {
            final refreshToken = await _tokenService.getRefreshToken();

            if (refreshToken != null) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: baseApiUrl));
                final response = await refreshDio.post('auth/token/refresh/', data: {'refresh': refreshToken});

                final newAccess = response.data['access'];
                final newRefresh = response.data['refresh'];
                final userId = response.data['user_id'];

                await _tokenService.saveTokens(access: newAccess, refresh: newRefresh, userId: userId);

                e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
                final clonedRequest = await _dio.fetch(e.requestOptions);
                return handler.resolve(clonedRequest);
              } catch (refreshError) {
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

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
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
