import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/search/row_container.dart';

class LocationInputRow extends StatelessWidget {
  final TextEditingController controller;

  const LocationInputRow({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return RowContainer(
      child: Row(
        children: [
          const Icon(
              Icons.location_on_outlined,
              color: AppColors.gray2
          ),
          const SizedBox(width: 12),
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
