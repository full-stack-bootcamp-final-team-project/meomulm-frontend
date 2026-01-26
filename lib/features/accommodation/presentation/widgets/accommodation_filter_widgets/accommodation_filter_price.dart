import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_filter_provider.dart';
import 'package:provider/provider.dart';


class AccommodationFilterPrice extends StatelessWidget {
  const AccommodationFilterPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccommodationFilterProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('가격 범위', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        RangeSlider(
          min: 0,
          max: 480,
          divisions: 48,
          values: provider.priceRange,
          labels: RangeLabels(
            '${provider.priceRange.start.toInt()}만원',
            '${provider.priceRange.end.toInt()}만원',
          ),
          onChanged: provider.setPrice,
        ),
      ],
    );
  }
}
