class ErrorResponseModel {
  final int status;
  final String code;
  final String message;

  ErrorResponseModel({
    required this.status,
    required this.code,
    required this.message,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      status: json['status'],
      code: json['error'],
      message: json['message'],
    );
  }
}
