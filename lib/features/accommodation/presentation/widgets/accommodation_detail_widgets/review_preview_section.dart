// lib/features/accommodation/presentation/widgets/accommodation_detail/review_preview_section.dart

import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

class ReviewPreviewSection extends StatelessWidget {
  final String rating;
  final String count;
  final String desc;
  final VoidCallback onReviewTap;

  const ReviewPreviewSection({
    super.key,
    required this.rating,
    required this.count,
    required this.desc,
    required this.onReviewTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                  AppIcons.star,
                  color: AppColors.ratingColor,
                  size: AppIcons.sizeXs
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                  rating,
                  style: AppTextStyles.bodyMd
              ),
              const SizedBox(width: 8),

              GestureDetector(
                onTap: onReviewTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  '리뷰 $count개',
                  style: AppTextStyles.bodyMdGray
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            desc,
            style: const TextStyle(color: AppColors.gray3, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}