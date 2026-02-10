/// ===============================
/// 마이페이지 스크린 모델
/// ===============================
class UserProfileModel {
  final int userId;
  final String userEmail;
  final String userName;
  final String userPhone;
  final String? userProfileImage;
  final String userBirth;

  const UserProfileModel({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
    this.userProfileImage,
    required this.userBirth,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'],
      userEmail: json['userEmail'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      userProfileImage: json['userProfileImage'],
      userBirth: json['userBirth'],
    );
  }

  DateTime _parseDate(String userBirth) {
    final parts = userBirth.split("-");
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  String get _userBirth => userBirth;

  DateTime get parsedUserBirth => _parseDate(_userBirth);

  String get birthYear => '${parsedUserBirth.year}';
  String get birthMonth => parsedUserBirth.month.toString().padLeft(2, '0');
  String get birthDay => parsedUserBirth.day.toString().padLeft(2, '0');
}