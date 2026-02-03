class AppException implements Exception {
  final int status;
  final String code;
  final String message;

  AppException({
    required this.status,
    required this.code,
    required this.message,
  });
}
