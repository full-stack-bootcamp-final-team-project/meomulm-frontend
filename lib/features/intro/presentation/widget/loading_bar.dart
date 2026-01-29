import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 진행률(Progress) 바 표시
class LoadingBar extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0 진행률
  const LoadingBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      // 로딩바 배경
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress, // 진행률에 따라 너비 변경
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.ratingColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
