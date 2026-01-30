import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 내 위치로 이동 버튼
class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyLocationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: FloatingActionButton(
            heroTag: "myLocationBtn",
            backgroundColor: AppColors.white,
            onPressed: onPressed,
            child: const Icon(
              AppIcons.location,
              color: AppColors.main,
            ),
          ),
        ),
      ),
    );
  }
}