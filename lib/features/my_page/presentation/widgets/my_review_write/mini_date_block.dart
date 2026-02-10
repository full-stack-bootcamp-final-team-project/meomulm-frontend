import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

/// ===============================
/// 체크인/체크아웃 위젯
/// ===============================
class MiniDateBlock extends StatelessWidget {
  final String label;
  final String value;

  const MiniDateBlock({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.buttonSm.copyWith(
            color: AppColors.gray2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.bodyMd,
        ),
      ],
    );
  }
}