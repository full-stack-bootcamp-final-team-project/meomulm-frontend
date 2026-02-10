import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 하트 (누르면 alert 뜨고 찜 해제)
class FavoriteHeartIcon extends StatelessWidget {
  final VoidCallback onUnfavorite;

  const FavoriteHeartIcon({
    super.key,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppIcons.sizeXxl,
      height: AppIcons.sizeXxl,
      decoration: const BoxDecoration(
        color: AppColors.gray5,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onUnfavorite,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(
          Icons.favorite,
          color: Colors.red,
          size: AppIcons.sizeMd,
        ),
      ),
    );
  }
}
