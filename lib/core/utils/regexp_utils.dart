import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/ui/regexp_constants.dart';

class RegexpUtils {
  // 이메일 검증
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return InputMessages.emptyEmail;
    }
    // 입력을 시작했으면 검증
    if (!RegexpConstants.email.hasMatch(email)) {
      return InputMessages.invalidEmail;
    }
    return null;
  }

  // 비밀번호 검증
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return InputMessages.emptyPassword;
    }
    if (!RegexpConstants.password.hasMatch(value)) {
      return InputMessages.invalidPassword;
    }
    return null;
  }

  // 비밀번호 확인 검증
  static String? validateCheckPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (password != value) {
      return InputMessages.mismatchPassword;
    }
    return null;
  }



  // 이름 검증
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return InputMessages.emptyName;
    }
    if (!RegexpConstants.name.hasMatch(name)) {
      return InputMessages.invalidName;
    }
    return null;
  }

  // 전화번호 검증
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return InputMessages.emptyPhone;
    }
    if (!RegexpConstants.phone.hasMatch(phone)) {
      return InputMessages.invalidPhone;
    }
    if (phone.length < 10) {
      return '전화번호는 최소 10자리 이상이어야 합니다.';
    }
    if (phone.length > 11) {
      return '전화번호는 11자리 이하여야 합니다.';
    }
    return null;
  }

}