import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

/// 지역 선택 UI 위젯
class LocationSelectRow extends StatelessWidget {
  final String region;
  final VoidCallback onTap;

  const LocationSelectRow({
    super.key,
    required this.region,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            const Icon(AppIcons.locationOn),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                region.isEmpty ? '지역 선택' : region,
                style: AppTextStyles.bodyLg,
              ),
            ),
            const Icon(AppIcons.arrowRight),
          ],
        ),
      ),
    );
  }
}