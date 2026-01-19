class SignupRequest {
  final String userEmail;
  final String userPassword;
  final String userName;
  final String? userPhone;
  final String? userBirth;

  SignupRequest({
    required this.userEmail,
    required this.userPassword,
    required this.userName,
    this.userPhone,
    this.userBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userName': userName,
      if (userPhone != null) 'userPhone': userPhone,
      if (userBirth != null) 'userBirth': userBirth,
    };
  }

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      userEmail: json['userEmail'] as String,
      userPassword: json['userPassword'] as String,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String?,
      userBirth: json['userBirth'] as String?,
    );
  }
}