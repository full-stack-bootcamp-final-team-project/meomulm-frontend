import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_button_styles.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

// =====================
// 버튼 위젯 컴포넌트
// =====================
// Global Large Button
class LargeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; // 터치되었을 때 동작
  final bool enabled;           // 서비스 로직 상 제출 가능 상태인지 여부

  const LargeButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: AppButtonStyles.globalButtonStyle(enabled: enabled).copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthLg,
            AppButtonStyles.buttonHeightLg,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthLg,
            AppButtonStyles.buttonHeightLg,
          ),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.buttonLg,
        maxLines: 1,
      ),
    );
  }
}

// Global Medium Button
class MediumButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; // 터치되었을 때 동작
  final bool enabled;           // 서비스 로직 상 제출 가능 상태인지 여부

  const MediumButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: AppButtonStyles.globalButtonStyle(enabled: enabled).copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthMd,
            AppButtonStyles.buttonHeightMd,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthMd,
            AppButtonStyles.buttonHeightMd,
          ),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.buttonMd,
        maxLines: 1,
      ),
    );
  }
}

// Global Small Button
class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; // 터치되었을 때 동작
  final bool enabled;           // 서비스 로직 상 제출 가능 상태인지 여부

  const SmallButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: AppButtonStyles.globalButtonStyle(enabled: enabled).copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            double.infinity,
            AppButtonStyles.buttonHeightSm,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.buttonWidthSm,
            AppButtonStyles.buttonHeightSm,
          ),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.buttonSm,
        maxLines: 1,
      ),
    );
  }
}



// input과 나란히 있는 버튼
Widget buildFieldWithButton({
  required Widget field,
  VoidCallback? onPressed,
  required String label,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: field),
      const SizedBox(width: 10),
      Container(
        margin: const EdgeInsets.only(top: 23),
        height: 55,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            backgroundColor: AppColors.main,
            foregroundColor: AppColors.white,
          ),
          child: Text(label),
        ),
      ),
    ],
  );
}

// Option Button
class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; // 터치되었을 때 동작

  const OptionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyles.optionButtonStyle().copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.optionButtonWidth,
            AppButtonStyles.optionButtonHeight,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.optionButtonWidth,
            AppButtonStyles.optionButtonHeight,
          ),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
      ),
    );
  }
}


// Option Cancel Button
class OptionCancelButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; // 터치되었을 때 동작

  const OptionCancelButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyles.optionCancelButtonStyle().copyWith(
        fixedSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.optionButtonWidth,
            AppButtonStyles.optionButtonHeight,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(
            AppButtonStyles.optionButtonWidth,
            AppButtonStyles.optionButtonHeight,
          ),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
      ),
    );
  }
}
