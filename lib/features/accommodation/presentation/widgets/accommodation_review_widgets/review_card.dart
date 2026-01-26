import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final String reviewDate;
  final double reviewRating;        // 필수 추가
  final String reviewText;

  const ReviewCard({
    super.key,
    required this.reviewerName,
    required this.reviewDate,
    required this.reviewRating,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 날짜 + 별점
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reviewDate,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // 별점 (노란색)
              Row(
                children: List.generate(5, (index) {
                  if (index < reviewRating.floor()) {
                    return const Icon(Icons.star, color: Colors.amber, size: 20);
                  } else if (index < reviewRating) {
                    return const Icon(Icons.star_half, color: Colors.amber, size: 20);
                  } else {
                    return const Icon(Icons.star_border, color: Colors.amber, size: 20);
                  }
                }),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 리뷰 텍스트 (연한 파랑 배경)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              reviewText,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}