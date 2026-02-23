class ChangePasswordModel {
  final String userEmail;
  final String? userPassword;

  ChangePasswordModel({
    required this.userEmail,
    this.userPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      userEmail: json['userEmail'],
      userPassword: json['userPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      if (userPassword != null) 'userPassword': userPassword,
    };
  }

  ChangePasswordModel copyWith({
    int? userId,
    String? userPassword,
  }) {
    return ChangePasswordModel(
      userEmail: userEmail,
      userPassword: userPassword ?? this.userPassword,
    );
  }
}