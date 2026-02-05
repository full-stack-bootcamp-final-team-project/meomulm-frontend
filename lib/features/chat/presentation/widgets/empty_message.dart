import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: AppIcons.sizeXxl, color: AppColors.gray3),
          SizedBox(height: AppSpacing.lg),
          Text('대화를 시작하세요', style: TextStyle(color: AppColors.gray2)),
        ],
      ),
    );
  }
}