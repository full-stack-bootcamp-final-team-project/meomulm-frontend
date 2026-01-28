/// ===============================
/// 마이페이지 스크린 모델
/// ===============================
class UserProfileModel {
  final int userId;
  final String userEmail;
  final String userName;
  final String userPhone;
  final String? userProfileImage;

  const UserProfileModel({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
    this.userProfileImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'],
      userEmail: json['userEmail'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      userProfileImage: json['userProfileImage'],
    );
  }
}