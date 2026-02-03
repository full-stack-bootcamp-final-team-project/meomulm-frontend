import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';


// 에러 메시지 위젯
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.lg,
      left:  AppSpacing.lg,
      right:  AppSpacing.lg,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Row(
            children: [
              Icon(AppIcons.error,color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.textError,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
