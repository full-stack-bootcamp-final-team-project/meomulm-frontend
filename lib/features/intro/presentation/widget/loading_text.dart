import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 하단에 표시되는 "loading..." 텍스트
class LoadingText extends StatelessWidget {
  const LoadingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'loading...',
      textAlign: TextAlign.center,
      style: AppTextStyles.bodyMd.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      )
    );
  }
}