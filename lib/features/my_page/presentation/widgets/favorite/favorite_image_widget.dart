import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/accommodation_image_utils.dart';

/// 숙소 이미지 영역
class FavoriteImage extends StatefulWidget {
  final String imageUrl;

  const FavoriteImage({super.key, required this.imageUrl});

  @override
  State<FavoriteImage> createState() => _FavoriteImageState();
}

class _FavoriteImageState extends State<FavoriteImage> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: AccommodationImageUtils.isNetworkImage(widget.imageUrl)
        ? Image.network(
          widget.imageUrl,
          width: 100,
          height: 140,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _placeholder();
          },
          errorBuilder: (_, __, ___) => _placeholder(),
        )
        // asset 이미지
        : Image.asset(
          widget.imageUrl,
          width: 100,
          height: 140,
          fit: BoxFit.cover,
        ),
    );
  }

  Widget _placeholder() {
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
}