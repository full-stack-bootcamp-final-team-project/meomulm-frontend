import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'icon_text_row.dart';

class PolicySection extends StatelessWidget {
  const PolicySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('숙소 규정', style: AppTextStyles.cardTitle),
          SizedBox(height: AppSpacing.md),
          IconTextRow(value: '미성년자는 예약 및 숙박 불가합니다.'),
          IconTextRow(value: '체크인 기준 3일 전까지 예약 취소 가능합니다.'),
        ],
      ),
    );
  }
}