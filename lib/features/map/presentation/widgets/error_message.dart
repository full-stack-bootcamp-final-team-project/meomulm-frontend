import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 지도에서 에러 메시지를 표시하는 위젯
class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessage({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.lg),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.main,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: AppColors.error),
            boxShadow: AppShadows.small,
          ),
          child: Row(
            children: [
              Icon(
                AppIcons.errorOutline,
                size: AppIcons.sizeLg,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.textError,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  child: const Text(
                    '재시도',
                    style: AppTextStyles.bodyXl
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}