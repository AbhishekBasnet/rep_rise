import 'package:dio/dio.dart';
import 'dart:convert';

class ApiClient {
  static const String baseApiUrl = "http://10.0.2.2:8000/";
  final String _username = "joshua";
  final String _password = "1902";
  late final Dio dio;
  ApiClient() {
    // 1. Create the Basic Auth string
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';

    dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': basicAuth, // 2. Attach the credentials here
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

}