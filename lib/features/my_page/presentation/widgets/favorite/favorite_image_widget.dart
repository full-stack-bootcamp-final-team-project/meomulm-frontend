import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 숙소 이미지 영역
class FavoriteImage extends StatefulWidget {
  final String? imageUrl;

  const FavoriteImage({super.key, this.imageUrl});

  @override
  State<FavoriteImage> createState() => _FavoriteImageState();
}

class _FavoriteImageState extends State<FavoriteImage> {

  @override
  Widget build(BuildContext context) {

    // 이미지 URL이 없으면 기본 아이콘 보여주기
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
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
    }

    // 이미지 URL이 있으면 Image.network로 표시
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child:
      Image.network(
        widget.imageUrl!,
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

        // 이미지 로드 실패
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