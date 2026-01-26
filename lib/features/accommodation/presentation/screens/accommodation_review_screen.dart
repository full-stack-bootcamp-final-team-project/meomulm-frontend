import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_review_widgets/review_card.dart';

class AccommodationReviewScreen extends StatelessWidget {
  const AccommodationReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarWidget(title: "숙소 리뷰"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),

              // 상단 전체 평점 (노란 별 + 4.5 + 평가 수)
              _buildOverallreviewRating(),

              const SizedBox(height: 32),

              // 구분선 (끝까지)
              // const Divider(thickness: 1, height: 1, color: Color(0xFFC1C1C1)),

              const SizedBox(height: 20),

              // 리뷰 리스트 (90% 너비)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: const [
                    ReviewCard(
                      reviewerName: '김도영',
                      reviewDate: '2025.12.28',
                      reviewRating: 4.5,
                      reviewText: '완전 별로입니다.',
                    ),
                    SizedBox(height: 16),
                    ReviewCard(
                      reviewerName: '김도영',
                      reviewDate: '2025.12.28',
                      reviewRating: 3.0,
                      reviewText: '완전 별로입니다.',
                    ),
                    SizedBox(height: 16),
                    ReviewCard(
                      reviewerName: '박지현',
                      reviewDate: '2025.11.30',
                      reviewRating: 5.0,
                      reviewText: '최고예요!!',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 전체 평점 위젯 (노란 별 + 4.5 + 평가 수)
  Widget _buildOverallreviewRating() {
    const double overallreviewRating = 4.5;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            if (index < overallreviewRating.floor()) {
              return const Icon(Icons.star, color: Colors.amber, size: 40);
            } else if (index < overallreviewRating) {
              return const Icon(Icons.star_half, color: Colors.amber, size: 40);
            } else {
              return const Icon(Icons.star_border, color: Colors.amber, size: 40);
            }
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          '4.5',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          '311개 평가',
          style: TextStyle(fontSize: 16, color: Color(0xFF8B8B8B)),
        ),
      ],
    );
  }
}