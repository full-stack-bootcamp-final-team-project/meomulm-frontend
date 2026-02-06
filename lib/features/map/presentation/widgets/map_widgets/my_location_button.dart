import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 내 위치로 이동하는 버튼 위젯
class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasSelectedAccommodation;

  const MyLocationButton({
    super.key,
    required this.onPressed,
    this.hasSelectedAccommodation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSpacing.lg,
      bottom: 0,
      child: SafeArea(
        child: AnimatedPadding(
          duration:AppDurations.medium,
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
            bottom: hasSelectedAccommodation ? 380.0 : 16.0,
          ),
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.gray1,
            elevation: 4,
            child: const Icon(AppIcons.location),
          ),
        ),
      ),
    );
  }
}