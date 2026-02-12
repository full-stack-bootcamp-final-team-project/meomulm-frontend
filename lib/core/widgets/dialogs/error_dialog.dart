import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;
  final String? title;
  final String? type;

  const ErrorDialog({
    super.key,
    required this.message,
    this.onConfirm,
    this.title,
    this.type,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'info' ? Icons.info_outline : Icons.error_outline,
              color: type == 'info' ? AppColors.gray2 : AppColors.error,
              size: AppIcons.sizeXxl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
                title ?? '오류',
                style: type == 'info' ? AppTextStyles.bodyXl:  AppTextStyles.textError,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm), // ✅
                  ),
                ),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
