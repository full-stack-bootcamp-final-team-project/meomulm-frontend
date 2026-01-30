import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 숙소 개수 표시 위젯
class AccommodationCounter extends StatelessWidget {
  final int count;

  const AccommodationCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.lg,
      left: AppSpacing.lg,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppBorderRadius.xxxl),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.xxxl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.accommodation,
                size: AppIcons.sizeSm,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '반경 ${MapConstants.searchRadius.toInt()}km 내 $count개 숙소',
                style: AppTextStyles.bodyMd
              ),
            ],
          ),
        ),
      ),
    );
  }
}
