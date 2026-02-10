class LoginRequestModel {
  final String userEmail;
  final String userPassword;

  LoginRequestModel({
    required this.userEmail,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userPassword': userPassword,
    };
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      userEmail: json['userEmail'] as String,
      userPassword: json['userPassword'] as String,
    );
  }
}