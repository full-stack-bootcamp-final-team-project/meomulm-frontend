import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

/// ===============================
/// 예약 상태 블록
/// ===============================
class StatusBlock extends StatelessWidget {
  final String title;

  const StatusBlock({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if(title == "예약확정") {
      return _StatusBlockStyle(
        title: title,
        backgroundColor: AppColors.selectedLight,
        textColor: AppColors.menuSelected,
      );
    }

    if(title == "이용완료") {
      return _StatusBlockStyle(
        title: title,
        backgroundColor: AppColors.gray4,
        textColor: AppColors.gray2,
      );
    }

    return _StatusBlockStyle(
      title: title,
      backgroundColor: AppColors.cancelledLight,
      textColor: AppColors.cancelled,
    );
  }
}

/// ===============================
/// 예약 상태 블록 공통 스타일
/// ===============================
class _StatusBlockStyle extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  const _StatusBlockStyle({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 65,
      height: 27,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
        color: backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.buttonSm.copyWith(color: textColor),
        ),
      ),
    );
  }
}