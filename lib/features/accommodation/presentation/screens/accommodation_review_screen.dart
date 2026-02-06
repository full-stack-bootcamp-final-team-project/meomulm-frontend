import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_review_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/review_summary.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_review_widgets/review_card.dart';

class AccommodationReviewScreen extends StatefulWidget {
  final int accommodationId;
  const AccommodationReviewScreen({super.key, required this.accommodationId});

  @override
  State<AccommodationReviewScreen> createState() => _AccommodationReviewScreenState();
}

class _AccommodationReviewScreenState extends State<AccommodationReviewScreen> {
  bool isLoading = true;
  ReviewSummaryModel? summary;
  List<AccommodationReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    _loadAllReviewData(widget.accommodationId);
  }

  Future<void> _loadAllReviewData(int id) async {
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        AccommodationApiService.getReviewSummary(id),
        AccommodationApiService.getReviewsByAccommodationId(id),
      ]);

      setState(() {
        summary = results[0] as ReviewSummaryModel?;
        reviews = results[1] as List<AccommodationReviewModel>;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(title: "숙소 리뷰"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              // 상단 요약 (실제 데이터 반영)
              _buildOverallReviewRating(
                summary?.averageRating ?? 0.0,
                summary?.totalCount ?? 0,
              ),
              const SizedBox(height: 32),
              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
              const SizedBox(height: 20),

              // 리뷰 리스트
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: reviews.isEmpty
                    ? const Center(child: Text("첫 리뷰를 작성해 주세요!"))
                    : ListView.separated(
                  shrinkWrap: true, // ScrollView 안에서 사용하기 위함
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = reviews[index];
                    return ReviewCard(
                      reviewerName: item.userName ?? '익명',
                      reviewDate: item.createdAt.split('T')[0], // 날짜 형식 처리
                      reviewRating: item.rating.toDouble(),
                      reviewText: item.reviewContent,
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallReviewRating(double rating, int count) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            double diff = rating - index;
            if (diff >= 1) {
              return const Icon(Icons.star, color: Colors.amber, size: 40);
            } else if (diff >= 0.5) {
              return const Icon(Icons.star_half, color: Colors.amber, size: 40);
            } else {
              return const Icon(Icons.star_border, color: Colors.amber, size: 40);
            }
          }),
        ),
        const SizedBox(height: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '$count개 평가',
          style: const TextStyle(fontSize: 16, color: Color(0xFF8B8B8B)),
        ),
      ],
    );
  }
}