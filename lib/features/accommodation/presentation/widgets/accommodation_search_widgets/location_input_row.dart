import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';

class LocationInputRow extends StatelessWidget {
  final TextEditingController controller;

  const LocationInputRow({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppIcons.sizeXxxxl,
      child: Row(
        children: [
          const Icon(AppIcons.search),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '숙소명, 지역',
                border: InputBorder.none,
                isDense: true,
              ),
              style: AppTextStyles.inputTextLg,
            ),
          ),
        ],
      ),
    );
  }
}
