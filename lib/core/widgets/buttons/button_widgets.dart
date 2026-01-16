import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_button_styles.dart';

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
            AppButtonStyles.buttonWidthSm,
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
        maxLines: 1,
      ),
    );
  }
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
