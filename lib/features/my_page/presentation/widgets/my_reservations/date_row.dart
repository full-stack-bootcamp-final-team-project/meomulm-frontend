import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

/// ===============================
/// 체크인/체크아웃 라인
/// ===============================
class DateRow extends StatelessWidget {
  final String checkInDate;
  final String checkOutDate;
  final Color labelColor;
  final Color valueColor;

  const DateRow({
    required this.checkInDate,
    required this.checkOutDate,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "체크인",
                style: AppTextStyles.bodyXs.copyWith(color: labelColor),
              ),
              Text(
                checkInDate,
                style: AppTextStyles.bodyMd.copyWith(color: valueColor),
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),


        const SizedBox(width: AppSpacing.sm),
        const SizedBox(
          height: AppSpacing.xxl,
          child: VerticalDivider(
            width: AppBorderWidth.md,
            thickness: AppBorderWidth.md,
            color: AppColors.gray3,
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "체크아웃",
                style: AppTextStyles.bodyXs.copyWith(color: labelColor),
              ),
              Text(
                checkOutDate,
                style: AppTextStyles.bodyMd.copyWith(color: valueColor),
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),
      ],
    );
  }
}