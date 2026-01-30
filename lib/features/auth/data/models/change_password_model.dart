class ChangePasswordModel {
  final int userId;
  final String? userPassword;

  ChangePasswordModel({
    required this.userId,
    this.userPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      userId: json['userId'] as int,
      userPassword: json['userPassword'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      if (userPassword != null) 'userPassword': userPassword,
    };
  }

  ChangePasswordModel copyWith({
    int? userId,
    String? userPassword,
  }) {
    return ChangePasswordModel(
      userId: userId ?? this.userId,
      userPassword: userPassword ?? this.userPassword,
    );
  }
}