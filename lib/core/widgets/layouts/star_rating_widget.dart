import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

// 별점
// builder: (context, state) => const StarRatingWidget(rating: 3.5) 사용시에 점수 입력해서 넘겨줘야함
class StarRatingWidget extends StatelessWidget {
  final double rating; // 0.0 ~ 5.0
  final double size;
  final Color color;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = AppIcons.sizeXs,
    this.color = AppColors.ratingColor,
  });

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    final empty = 5 - full - (hasHalf ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < full; i++)
          Icon(AppIcons.star, size: size, color: color),
        if (hasHalf) Icon(AppIcons.starHalf, size: size, color: color),
        for (int i = 0; i < empty; i++)
          Icon(AppIcons.starBorder, size: size, color: color),
      ],
    );
  }
}