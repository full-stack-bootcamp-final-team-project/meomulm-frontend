import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class BottomActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const BottomActionButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: AppShadows.bottomNav,
      ),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * BottomActionButtonDimensions.widthPercentage,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onPressed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              elevation: 0,
            ),
            child: Text(
              label,
              style: AppTextStyles.buttonLg
            ),
          ),
        ),
      ),
    );
  }
}