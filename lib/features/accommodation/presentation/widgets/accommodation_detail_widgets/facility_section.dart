import 'package:flutter/material.dart';
import 'facility_list.dart';

class FacilitySection extends StatelessWidget {
  final List<String> labels;

  const FacilitySection({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('시설/서비스', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          FacilityList(initialShowCount: 6, facilities: labels),
        ],
      ),
    );
  }
}