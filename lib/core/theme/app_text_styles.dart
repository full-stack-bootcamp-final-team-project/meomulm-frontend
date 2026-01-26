import 'package:flutter/material.dart';
import 'app_colors.dart';

/// =====================
/// 텍스트 스타일 정의
/// =====================
class AppTextStyles {
  AppTextStyles._();

  /// =====================
  /// 제목
  /// =====================
  static const appBarTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const cardTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const subTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  /// =====================
  /// 입력창
  /// =====================
  static const inputLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const inputTextSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const inputTextMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const inputTextLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const inputPlaceholder = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray3,
  );

  static const inputError = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const inputSuccess = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const inputDisable = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.gray3,
  );

  /// =====================
  /// 버튼
  /// =====================
  static const buttonSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const buttonMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const buttonLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const kakaoLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xD9000000),
  );

  static const naverLg = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color:Color(0xFFFFFFFF),
  );

  /// =====================
  /// 기본 텍스트
  /// =====================
  static const bodyXs = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const textError = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.error,
  );

}
