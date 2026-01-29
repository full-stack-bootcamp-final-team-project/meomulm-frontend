class RegexpConstants {
  RegexpConstants._();

  // 이메일 형식
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  // 비밀번호 형식
  static final password = RegExp(r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/~`]{8,16}$');
  // 숫자 형식
  static final phone = RegExp(r'^[0-9]+$');
  // 한글 ~ 영어 형식
  static final name = RegExp(r'[^가-힣a-zA-Z]');
}
