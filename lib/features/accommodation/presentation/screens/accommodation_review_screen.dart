import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
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
              const SizedBox(height: AppSpacing.xxl),
              _buildOverallReviewRating(
                summary?.averageRating ?? 0.0,
                summary?.totalCount ?? 0,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const Divider(thickness: AppSpacing.xs, color: AppColors.gray5),
              const SizedBox(height: AppSpacing.xl),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: reviews.isEmpty
                    ? const Center(child: Text("첫 리뷰를 작성해 주세요!"))
                    : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    final item = reviews[index];
                    return ReviewCard(
                      reviewerName: item.userName ?? '익명',
                      reviewDate: item.createdAt.split('T')[0],
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
              return const Icon(
                AppIcons.star,
                color: AppColors.ratingColor,
                size: AppIcons.sizeXxl
              );
            } else if (diff >= 0.5) {
              return const Icon(
                AppIcons.starHalf,
                color: AppColors.ratingColor,
                size: AppIcons.sizeXxl
              );
            } else {
              return const Icon(
                AppIcons.starBorder,
                color: AppColors.ratingColor,
                size: AppIcons.sizeXxl
              );
            }
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.reviewPoint
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$count개 평가',
          style: AppTextStyles.bodyLg,
        ),
      ],
    );
  }
}