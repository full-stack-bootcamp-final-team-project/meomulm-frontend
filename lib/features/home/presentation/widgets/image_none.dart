import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 이미지 없을 때 보여주는 위젯
class ImageNone extends StatelessWidget {
  const ImageNone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
        color: AppColors.gray5,
      ),
      alignment: Alignment.center,
      child: Icon(
        AppIcons.image,
        color: AppColors.gray3,
        size: AppIcons.sizeXxl,
      ),
    );
  }
}