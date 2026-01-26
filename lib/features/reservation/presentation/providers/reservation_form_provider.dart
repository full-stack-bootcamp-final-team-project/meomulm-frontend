import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

class ReservationFormProvider extends ChangeNotifier {
  // =========================
  // 입력값 상태
  // =========================
  String name = '';
  String email = '';
  String phone = '';

  // 에러 메시지
  String? nameError;
  String? emailError;
  String? phoneError;


  // =========================
  // setters (입력값 변경)
  // =========================
  void setName(String value) {
    name = value;
    _validateName();
  }

  void setEmail(String value) {
    email = value;
    _validateEmail();
  }

  void setPhone(String value) {
    phone = value;
    _validatePhone();
  }

  // =========================
  // 검증 로직
  // =========================
  void _validateName() {
    if (name.isNotEmpty &&
        !RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      nameError = InputMessages.invalidName;
    } else {
      nameError = null;
    }

    notifyListeners();
  }

  void _validateEmail() {
    if (email.isEmpty) {
      emailError = null; // 비어있으면 에러 없음
    } else if (!email.contains('@')) {
      emailError = InputMessages.invalidEmail;
    } else {
      emailError = null; // 정상
    }
    notifyListeners();
  }

  void _validatePhone() {
    if (phone.isEmpty) {
      phoneError = null;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      phoneError = InputMessages.invalidPhone;
    } else {
      phoneError = null;
    }
    notifyListeners();
  }

  // =========================
  // 버튼 활성화 여부
  // =========================
  bool get canSubmit =>
      name.isNotEmpty &&
          email.isNotEmpty &&
          phone.isNotEmpty &&
          nameError == null &&
          emailError == null &&
          phoneError == null;
}

