import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';

class ReservationImageWidget extends StatefulWidget {
  final String? imageUrl;

  const ReservationImageWidget({super.key, this.imageUrl});

  @override
  State<ReservationImageWidget> createState() => _ReservationImageWidget();
}

class _ReservationImageWidget extends State<ReservationImageWidget> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageUrl?.trim() ?? '';

    if(imageUrl.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        color: AppColors.gray5,
        alignment: Alignment.center,
        child: Icon(
          Icons.image,
          color: AppColors.gray3,
          size: AppIcons.sizeXxl,
        )
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Image.network(
        imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        // 이미지 로딩
        loadingBuilder: (context, child, loadingProgress) {
          if(loadingProgress == null) return child;
          return Container(
            width: 64,
            height: 64,
            color: AppColors.gray5,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2,)
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 64,
            height: 64,
            color: AppColors.gray5,
            alignment: Alignment.center,
            child: Icon(
              Icons.image,
              color: AppColors.gray3,
              size: AppIcons.sizeXxl,
            )
          );
        },
      )
    );
  }

}