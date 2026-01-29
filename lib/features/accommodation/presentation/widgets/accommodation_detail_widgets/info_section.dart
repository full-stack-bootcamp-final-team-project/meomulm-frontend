import 'package:flutter/material.dart';
import 'icon_text_row.dart';

class InfoSection extends StatelessWidget {
  final String contact;

  const InfoSection({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('숙소 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          IconTextRow(label: '연락처', value: contact),
        ],
      ),
    );
  }
}