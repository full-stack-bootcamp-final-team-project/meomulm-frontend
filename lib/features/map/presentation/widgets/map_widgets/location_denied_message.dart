import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 위치 권한 메시지 위젯
class LocationDeniedMessage extends StatelessWidget {
  const LocationDeniedMessage();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.lg,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.main,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(AppIcons.locationOff),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                        PermissionMessages.needLocationPermission,
                      style: AppTextStyles.bodyLg
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                PermissionMessages.settingLocationPermission,
                style:  AppTextStyles.bodyMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
