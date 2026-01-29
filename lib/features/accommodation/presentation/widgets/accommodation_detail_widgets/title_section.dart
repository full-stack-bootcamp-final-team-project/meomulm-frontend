import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String name;

  const TitleSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),   // ← 여기서 12px 여백 확보
        ],
      ),
    );
  }
}