import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/ui/regexp_constants.dart';

class RegexpUtils {
  // 이메일 검증
  static String? RegExpEmail(String email) {

    if (email.isEmpty) {
      return InputMessages.emptyEmail;
    }

    if (!RegexpConstants.email.hasMatch(email)) {
      return InputMessages.invalidEmail;
    }

    return null;
  }

  // 비밀번호 검증
  static String? RegExpPassword(String password) {

    if (password.isEmpty) {
      return InputMessages.emptyPassword;
    }
    if (!RegexpConstants.password.hasMatch(password)) {
      return InputMessages.invalidPassword;
    }
    return null;
  }


  // 이름 검증
  static String? RegExpName(String name) {

    if (name.isEmpty) {
      return InputMessages.emptyName;
    }

    if (RegexpConstants.phone.hasMatch(name)) {
      return '숫자는 입력할 수 없습니다.';
    }

    if (RegexpConstants.name.hasMatch(name)) {
      return InputMessages.invalidName;
    }

    return null;
  }

  // 전화번호 검증
  static String? RegExpPhone(String phone) {

    if (phone.isEmpty) {
      return InputMessages.emptyPhone;
    }

    if (!RegexpConstants.phone.hasMatch(phone)) {
      return '숫자만 입력 가능합니다.';
    } else if (phone.length > 11) {
      return '전화번호는 11자리 이상일 수 없습니다.';
    }

    return null;
  }




  // static String? validate(String name) {
  //   final trimmed = name.trim();
  //
  //   if (trimmed.isEmpty) {
  //     return "이름을 입력해주세요.";
  //   }
  //
  //   if (trimmed.length < 2) {
  //     return "이름은 최소 2글자 이상이어야 합니다.";
  //   }
  //
  //   if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(trimmed)) {
  //     return "한글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 불가)";
  //   }
  //
  //   return null;
  // }
}