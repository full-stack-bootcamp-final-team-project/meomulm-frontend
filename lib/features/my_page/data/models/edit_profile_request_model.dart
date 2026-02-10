/// ===============================
/// 프로필 수정 요청 모델
/// ===============================
class EditProfileRequestModel {
  final String userName;
  final String userPhone;

  const EditProfileRequestModel({
    required this.userName,
    required this.userPhone,
  });

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'userPhone': userPhone,
  };
}