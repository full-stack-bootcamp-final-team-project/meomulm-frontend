import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 프로필 이미지 섹션
class ProfileIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileIcon({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
          AppIcons.accountCircle,
          size: AppIcons.sizeXxl,
          color: AppColors.gray3),
    );
  }
}