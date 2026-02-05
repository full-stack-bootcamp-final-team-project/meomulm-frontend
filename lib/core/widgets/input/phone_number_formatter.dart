import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,  // 사용자가 입력한 전화번호
    TextEditingValue newValue,  // 대시(-) 추가한 전화번호
  ) {
    // 숫자만 추출
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    String formatted = digits;
    
    // 서울 지역번호 (02)
    if(digits.startsWith('02')) {
      if(digits.length <= 2) {
        formatted = digits;
      } else if(digits.length <= 5) {
        formatted = '${digits.substring(0, 2)}-${digits.substring(2)}';
      } else if(digits.length <= 9) {
        formatted = '${digits.substring(0, 2)}-${digits.substring(2, 5)}-${digits.substring(5)}';
      } else {
        formatted = '${digits.substring(0, 2)}-${digits.substring(2, 6)}-${digits.substring(6, 10)}';
      }
    }
    
    // 휴대폰
    else if(digits.startsWith('01')) {
      if(digits.length <= 3) {
        formatted = digits;
      } else if(digits.length <= 7) {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
      } else {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
      }
    }

    // 기타 지역번호
    else {
      if(digits.length <= 3) {
        formatted = digits;
      } else if(digits.length <= 6) {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
      } else if(digits.length <= 10) {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
      } else {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}