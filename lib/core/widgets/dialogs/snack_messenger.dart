import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

enum ToastType { info, success, error }

class SnackMessenger {
  static void showMessage(
      BuildContext context,
      String message, {
        double? bottomPadding,
        ToastType type = ToastType.info,
      }
      ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();    // 이전 스낵바가 있다면 즉시 닫기

    final backgroundColor = switch (type) {                 // 타입에 따른 색상
      ToastType.success => AppColors.success,
      ToastType.error => AppColors.cancelled,
      _ => Colors.black87,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.white),
        ),
        behavior: SnackBarBehavior.floating,
        duration: AppDurations.snackbar,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: bottomPadding ?? 15,
        ),
      ),
    );
  }
}

/*
behavior: SnackBarBehavior.floating,
backgroundColor: Colors.black87,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
 */