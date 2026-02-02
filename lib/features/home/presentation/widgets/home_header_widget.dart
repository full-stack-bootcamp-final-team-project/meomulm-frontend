import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 헤더 영역(로고 + 알림)
class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback onLogoTap;
  const HomeHeaderWidget({super.key, required this.onLogoTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.xxxl + AppSpacing.md,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onLogoTap,
            child: Image.asset(
              'assets/images/main_logo.png',
              width: 60,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Text('머묾', style: AppTextStyles.appBarTitle.copyWith(color: Colors.white)),
            ),
          ),
          GestureDetector(
            onTap: () => context.pushNamed("notificationList"),
            child: Icon(
              AppIcons.notifications,
              color: AppColors.white,
              size: AppIcons.sizeXxl
            ),
          ),
        ],
      ),
    );
  }
}