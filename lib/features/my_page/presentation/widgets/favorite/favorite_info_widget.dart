import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 숙소 정보 영역
class FavoriteInfo extends StatelessWidget {
  final String accommodationName;
  final String location;

  const FavoriteInfo({super.key, required this.accommodationName, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xs),
        // 숙소명
        Text(accommodationName, style: AppTextStyles.cardTitle),
        const SizedBox(height: AppSpacing.xxs),
        // 숙소 위치
        Text(
          location,
          style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}