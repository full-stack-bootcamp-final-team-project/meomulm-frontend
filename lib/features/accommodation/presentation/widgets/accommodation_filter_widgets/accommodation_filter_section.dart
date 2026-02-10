import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_filter_widgets/accommodation_filter_button.dart';

class AccommodationFilterSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Set<String> selected;
  final Function(String) onToggle;

  const AccommodationFilterSection({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyLg),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((e) {
            return AccommodationFilterButton(
              label: e,
              selected: selected.contains(e),
              onTap: () => onToggle(e),
            );
          }).toList(),
        ),
      ],
    );
  }
}
