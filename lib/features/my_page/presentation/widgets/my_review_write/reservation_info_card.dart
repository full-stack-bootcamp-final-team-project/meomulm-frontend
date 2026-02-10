import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review_write/mini_date_block.dart';

/// ===============================
/// 상단 예약 정보 카드
/// ===============================
class ReservationInfoCard extends StatelessWidget {
  final ReservationShareModel reservationShare;

  const ReservationInfoCard({
    super.key,
    required this.reservationShare,
  });


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
                  // 숙소 사진
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gray5,
                      // borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                      image: DecorationImage(
                        image: NetworkImage(reservationShare.accommodationImageUrl ?? ''),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),

                  const SizedBox(width: AppSpacing.lg),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservationShare.accommodationName,
                          style: AppTextStyles.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        Text(
                          reservationShare.subtitle,
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
                          value: "${reservationShare.checkInText} 15:00"
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
                            value: "${reservationShare.checkOutDate} 11:00"
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