import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';

class BottomActionButton extends StatelessWidget {
  // TODO: VoidCallback onPressed로 교체
  // TODO: bool enable 받아오기
  // TODO: ElevatedButton -> LargeButton으로 교체
  final String label;
  final VoidCallback? onPressed;

  const BottomActionButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: AppShadows.bottomNav,
        ),
        child: Center(
          child: SizedBox(
            width:
            MediaQuery.of(context).size.width *
                BottomActionButtonDimensions.widthPercentage,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                elevation: 0,
              ),
              child: Text(label, style: AppTextStyles.buttonLg),
            ),
          ),
        ),
      ),
    );
  }
}