import 'package:dio/dio.dart';
import '../services/token_service.dart';

class ApiClient {
  static const String baseApiUrl = "http://10.0.2.2:8000/api/v1/";
  final Dio dio;
  final TokenService _tokenService;

  ApiClient(this._tokenService) : dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token = await _tokenService.getAccessToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // If the server returns 401, the token is likely expired
          if (e.response?.statusCode == 401) {
            await _tokenService.clearTokens();
            // TODO: Trigger a navigation to the login screen or a "Session Expired" notification
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}

