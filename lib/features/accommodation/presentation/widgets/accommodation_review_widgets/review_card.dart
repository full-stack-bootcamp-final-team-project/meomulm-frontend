import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final String reviewDate;
  final double reviewRating;        // 필수 추가
  final String reviewText;

  const ReviewCard({
    super.key,
    required this.reviewerName,
    required this.reviewDate,
    required this.reviewRating,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.gray4),
        borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 날짜 + 별점
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: AppTextStyles.bodyLg,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reviewDate,
                      style: AppTextStyles.bodySmGray,
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  if (index < reviewRating.floor()) {
                    return const Icon(AppIcons.star, color: AppColors.ratingColor, size: AppIcons.sizeMd);
                  } else if (index < reviewRating) {
                    return const Icon(AppIcons.starHalf, color: AppColors.ratingColor, size: AppIcons.sizeMd);
                  } else {
                    return const Icon(AppIcons.starBorder, color: AppColors.ratingColor, size: AppIcons.sizeMd);
                  }
                }),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.gray4,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Text(
              reviewText,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}