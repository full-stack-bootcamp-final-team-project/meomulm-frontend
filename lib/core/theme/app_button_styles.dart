import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

/// =====================
/// 버튼 스타일 정의
/// =====================
class AppButtonStyles {
  AppButtonStyles._();

  // 큰 사이즈 버튼
  static const double buttonWidthLg = 360.0;
  static const double buttonHeightLg = 52.0;
  // 중간 사이즈 버튼
  static const double buttonWidthMd = 167.0;
  static const double buttonHeightMd = 37.0;
  // 작은 사이즈 버튼
  static const double buttonWidthSm = 59.0;
  static const double buttonHeightSm = 47.0;
  // 옵션 버튼
  static const double optionButtonWidth = 161.0;
  static const double optionButtonHeight = 32.0;

  // Global Button Style (Large, Medium, Small 공통)
  static ButtonStyle globalButtonStyle({required bool enabled}) {
    return ElevatedButton.styleFrom(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      elevation: 0,
      backgroundColor: enabled
          ? AppColors.main
          : AppColors.disabled,
      foregroundColor: enabled
          ? AppColors.white
          : AppColors.gray2,
      disabledBackgroundColor: AppColors.disabled,
      disabledForegroundColor: AppColors.gray2,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mediumRadius,
      ),
    );
  }

  // Option Button Style
  static ButtonStyle optionButtonStyle() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.gray4,
      foregroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mediumRadius,
      ),
      textStyle: AppTextStyles.buttonMd,
    );
  }

  // Option Cancel Button Style
  static ButtonStyle optionCancelButtonStyle() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.cancelledLight,
      foregroundColor: AppColors.cancelled,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mediumRadius,
      ),
      textStyle: AppTextStyles.buttonMd,
    );
  }

  /// =====================
  /// 소셜 로그인 버튼
  /// =====================
  // Kakao Login Button
  static ButtonStyle kakaoLoginButtonStyle() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.kakaoBg,
      foregroundColor: AppColors.kakaoIcon,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.largeRadius,
      ),
      textStyle: AppTextStyles.kakaoLg,
    );
  }

  // Naver Login Button
  static ButtonStyle naverLoginButtonStyle() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.naverBg,
      foregroundColor: AppColors.naverIcon,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.smallRadius,
      ),
      textStyle: AppTextStyles.naverLg,
    );
  }
}