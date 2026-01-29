import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 리스트 양쪽 화살표 영역
class ArrowButtonWidget extends StatelessWidget {
  final double left;
  final double? top;
  final bool isLeft;
  final VoidCallback onTap;

  const ArrowButtonWidget({super.key, required this.left, this.top, required this.isLeft, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSpacing.lg + AppSpacing.xxs,
          height: AppSpacing.xl + AppSpacing.xxs,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.xs),
            border: Border.all(color: AppColors.gray4),
          ),
          child: Icon(isLeft ? AppIcons.arrowLeft : AppIcons.arrowRight, size: AppIcons.sizeSm, color: AppColors.gray1),
        ),
      ),
    );
  }
}