class UserModel {
  final int userId;
  final String userEmail;
  final String? userPassword;
  final String userName;
  final String? userPhone;
  final String? userBirth;
  final String? userProfileImage;
  final DateTime? createdAt;

  UserModel({
    required this.userId,
    required this.userEmail,
    this.userPassword,
    required this.userName,
    this.userPhone,
    this.userBirth,
    this.userProfileImage,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      userEmail: json['userEmail'] as String,
      userPassword: json['userPassword'] as String?,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String?,
      userBirth: json['userBirth'] as String?,
      userProfileImage: json['userProfileImage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      if (userPassword != null) 'userPassword': userPassword,
      'userName': userName,
      if (userPhone != null) 'userPhone': userPhone,
      if (userBirth != null) 'userBirth': userBirth,
      if (userProfileImage != null) 'userProfileImage': userProfileImage,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? userId,
    String? userEmail,
    String? userPassword,
    String? userName,
    String? userPhone,
    String? userBirth,
    String? userProfileImage,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userPassword: userPassword ?? this.userPassword,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userBirth: userBirth ?? this.userBirth,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}