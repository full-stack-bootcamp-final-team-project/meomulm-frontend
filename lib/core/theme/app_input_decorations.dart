import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';
import 'app_icons.dart';

/// =====================
/// TextField 입력 장식(InputDecoration) 정의
/// =====================
class AppInputDecorations {
  AppInputDecorations._();

  // 기본 스타일
  static InputDecoration standard({
    String? hintText,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.inputPlaceholder,
      errorText: errorText,
      errorStyle: AppTextStyles.inputError,
      focusColor: AppColors.main, // 추후 확인 요망 (cursorColor??)
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.gray3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.main),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.error, width: AppBorderWidth.lg),
      ),
    );
  }

  // Underline 스타일 (예약하기 참고)
  static InputDecoration underline({
    String? hintText,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.inputPlaceholder,
      errorText: errorText,
      errorStyle: AppTextStyles.inputError,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      border: const UnderlineInputBorder(),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray3),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.main),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: AppBorderWidth.lg),
      ),
    );
  }

  // Disabled 스타일 (회원정보 수정)
  static InputDecoration disabled() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: AppColors.gray6,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.gray4, width: AppBorderWidth.md),
      ),
    );
  }

  // Password 입력 필드 (visibility toggle 포함)
  static InputDecoration password({
    String? hintText,
    bool obscureText = true,
    VoidCallback? onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.inputPlaceholder,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.gray4, width: AppBorderWidth.md),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.main, width: AppBorderWidth.md),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mediumRadius,
        borderSide: const BorderSide(color: AppColors.error, width: AppBorderWidth.lg),
      ),
      suffixIcon: onToggleVisibility != null
          ? IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          obscureText ? AppIcons.visibilityOff : AppIcons.visibility,
        ),
        color: AppColors.gray4,
        splashRadius: AppSpacing.lg,
      )
          : null,
    );
  }
}

