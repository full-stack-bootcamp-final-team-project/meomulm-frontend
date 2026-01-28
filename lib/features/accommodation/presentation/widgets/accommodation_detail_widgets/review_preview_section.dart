// lib/features/accommodation/presentation/widgets/accommodation_detail/review_preview_section.dart

import 'package:flutter/material.dart';

class ReviewPreviewSection extends StatelessWidget {
  final String rating;
  final String count;
  final String desc;
  final VoidCallback onReviewTap;

  const ReviewPreviewSection({
    super.key,
    required this.rating,
    required this.count,
    required this.desc,
    required this.onReviewTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                  rating,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  )
              ),
              const SizedBox(width: 8),

              GestureDetector(
                onTap: onReviewTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  '리뷰 $count개',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}