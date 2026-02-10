import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'facility_list.dart';

class FacilitySection extends StatelessWidget {
  final List<String> labels;

  const FacilitySection({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('시설/서비스', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppSpacing.lg),
          FacilityList(initialShowCount: 6, facilities: labels),
        ],
      ),
    );
  }
}