class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic fullData;

  ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.fullData,
  });

  @override
  String toString() => message;
}