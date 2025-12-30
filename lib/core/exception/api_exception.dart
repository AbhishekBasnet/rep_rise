class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final String? detail;
  final dynamic fullData;

  ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.fullData,
    this.detail,
  });

  @override
  String toString() => message;
}