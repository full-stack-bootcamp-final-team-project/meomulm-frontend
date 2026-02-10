import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

// =====================
// 메뉴 항목
// =====================
class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const MenuItem({
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      title: Text(
          title,
          style: AppTextStyles.appBarTitle.copyWith(
            fontSize: 18,
            color: textColor != null ? textColor : null,
          )
      ),
      onTap: onTap,
    );
  }
}