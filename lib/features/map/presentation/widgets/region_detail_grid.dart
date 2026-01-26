import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';

class RegionDetailGrid extends StatelessWidget {
  final List<String> details;
  final int crossAxisCount;
  final ValueChanged<String>? onSelect;

  const RegionDetailGrid({
    super.key,
    required this.details,
    required this.crossAxisCount,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: details.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.xl,
        crossAxisSpacing: AppSpacing.xl,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          onTap: () => onSelect?.call(details[index]),
          child: Center(
            child: Text(
              details[index],
              style: AppTextStyles.bodyLg
            ),
          ),
        );
      },
    );
  }
}
