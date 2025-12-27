import 'package:dio/dio.dart';

class ApiClient {
  static const String baseApiUrl = "http://10.0.2.2:8000/";

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}