import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/layouts/star_rating_widget.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_response_model.dart';

/// ===============================
/// 리뷰 카드 UI
/// ===============================
class ReviewCard extends StatelessWidget {
  final ReviewResponseModel item;
  final VoidCallback onDeleteTap;

  const ReviewCard({
    required this.item,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppCardStyles.card,
      child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 숙소명 + 삭제 아이콘
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.accommodationName,
                      style: AppTextStyles.cardTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: onDeleteTap,
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      hoverColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                      highlightColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                      splashColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: Icon(
                          AppIcons.delete,
                          size: AppIcons.sizeSm,
                          color: AppColors.cancelled,
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              // 날짜 + 별점
              Row(
                children: [
                  Text(
                      item.createdAt,
                      style: AppTextStyles.inputPlaceholder.copyWith(color: AppColors.gray2)
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StarRatingWidget(rating: (item.rating * 1.0 / 2.0)),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // 리뷰 내용
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.gray5,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Text(
                  item.reviewContent,
                  style: AppTextStyles.inputTextMd.copyWith(height: 1.35),
                ),
              ),
            ],
          )
      ),
    );
  }
}