import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review_write/mini_date_block.dart';

/// ===============================
/// 상단 예약 정보 카드
/// ===============================
class ReservationInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: AppCardStyles.card,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 숙소 사진 영역
                  Container(
                    width: 48,
                    height: 48,
                    // TODO: 백엔드에서 불러온 숙소 사진으로 변경하기
                    decoration: BoxDecoration(
                      color: AppColors.gray5,
                      borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                    ),
                    child: const Center(
                      child: Icon(AppIcons.image, color: AppColors.gray3),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.lg),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "롯데 호텔 명동",  // TODO: 추후 백엔드 데이터로 교체
                          style: AppTextStyles.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        Text(
                          "스탠다드 룸 · 1박",  // TODO: 추후 백엔드 데이터로 교체
                          style: AppTextStyles.subTitle.copyWith(color: AppColors.gray2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: MiniDateBlock(
                          label: "체크인",
                          value: "12.14 (수) 15:00"  // TODO: 추후 백엔드 데이터로 교체
                      ),
                    ),

                    SizedBox(
                      height: 32,
                      child: VerticalDivider(
                        width: AppBorderWidth.md,
                        thickness: AppBorderWidth.md,
                        color: AppColors.gray4,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.lg),

                    Expanded(
                        child: MiniDateBlock(
                            label: "체크아웃",
                            value: "12.25 (목) 11:00"  // TODO: 추후 백엔드 데이터로 교체
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}