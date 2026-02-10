import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/date_row.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_reservations/reservation_image_widget.dart';

/// ===============================
/// 공통 카드 베이스
/// ===============================
class ReservationCardBase extends StatelessWidget {
  final Widget headerLeft;
  final String? accommodationImageUrl;
  final String hotelName;
  final String roomInfo;
  final String checkInValue;
  final String checkOutValue;

  final Widget? bottomAction;
  final bool isCanceled;

  const ReservationCardBase({
    super.key,
    required this.headerLeft,
    this.accommodationImageUrl,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInValue,
    required this.checkOutValue,
    this.bottomAction,
    this.isCanceled = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = AppColors.gray3;
    final valueColor = isCanceled ? AppColors.gray2 : AppColors.black;
    final isImageExists = accommodationImageUrl != null && accommodationImageUrl!.trim().isNotEmpty;


    return Container(
        decoration: AppCardStyles.card,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerLeft,
              const SizedBox(height: AppSpacing.md),
              const Divider(height: AppBorderWidth.md, thickness: AppBorderWidth.md,),
              const SizedBox(height: AppSpacing.md),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReservationImageWidget(imageUrl: accommodationImageUrl),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotelName,
                          style: AppTextStyles.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          roomInfo,
                          style: AppTextStyles.subTitle,
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: EdgeInsets.only(left:8),
                child: DateRow(
                    checkInDate: checkInValue,
                    checkOutDate: checkOutValue,
                    labelColor: labelColor,
                    valueColor: valueColor
                ),
              ),

              if (bottomAction != null) ...[
                const SizedBox(height: AppSpacing.sm),
                bottomAction!,
              ],
            ],
          ),
        )
    );
  }
}