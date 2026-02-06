import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: AppIcons.sizeMd,
            height: AppIcons.sizeMd,
            child: CircularProgressIndicator(),
          ),
          SizedBox(width: AppSpacing.sm),
          Text('AI가 생각중...'),
        ],
      ),
    );
  }
}