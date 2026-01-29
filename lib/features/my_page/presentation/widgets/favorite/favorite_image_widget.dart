import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 숙소 이미지 영역
class FavoriteImage extends StatelessWidget {
  final String? imageUrl;

  const FavoriteImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {

    if (imageUrl == null) {
      return Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.gray5,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.image,
          color: AppColors.gray3,
          size: AppIcons.sizeXxl,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Image.network(
        imageUrl!,
        width: 100,
        height: 140,
        fit: BoxFit.cover,
        // 이미지 로딩 중
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 100,
            height: 140,
            color: AppColors.gray5,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },

        // 이미지 로드 실패 / URL 없을 경우
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 140,
            color: AppColors.gray5,
            alignment: Alignment.center,
            child: Icon(
              Icons.image,
              color: AppColors.gray3,
              size: AppIcons.sizeXxl,
            ),
          );
        },
      ),
    );
  }
}