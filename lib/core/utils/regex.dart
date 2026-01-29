class Regex {
  // 이메일 정규식
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // 비밀번호 정규식 (8~16자, 영문 대소문자, 숫자, 특수문자 포함)
  static final RegExp password = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$',
  );

  // 숫자만 포함하는지 확인
  static final RegExp number = RegExp(r'^[0-9]+$');

  // 이름 정규식 (한글 또는 영문만 허용)
  static final RegExp name = RegExp(r'^[a-zA-Z가-힣]+$');

  // 전화번호 정규식 (숫자만, 10~11자리)
  static final RegExp phone = RegExp(r'^[0-9]{10,11}$');
}