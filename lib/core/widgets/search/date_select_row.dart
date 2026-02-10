import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class DateSelectRow extends StatelessWidget {
  final String dateText;
  final VoidCallback onTap;

  const DateSelectRow({super.key, required this.dateText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            const Icon(AppIcons.calendar),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                dateText,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyLg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
