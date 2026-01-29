import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_detail_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/review_summary.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/customer_divider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/facility_list.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/facility_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/icon_text_row.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/info_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/location_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/policy_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/review_preview_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/title_section.dart';
import '../widgets/accommodation_detail_widgets/accommodation_image_slider.dart';

class AccommodationDetailScreen extends StatefulWidget {
  final int accommodationId;
  const AccommodationDetailScreen({super.key, required this.accommodationId});

  @override
  State<AccommodationDetailScreen> createState() => _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {
  bool isLoading = true;
  AccommodationDetail? accommodation;
  ReviewSummary? reviewSummary;

  @override
  void initState() {
    super.initState();
    loadAccommodationDetail(widget.accommodationId);
  }

  Future<void> loadAccommodationDetail(int id) async {
    setState(() => isLoading = true);
    try {
      final results = await Future.wait([
        AccommodationApiService.getAccommodationById(id),
        AccommodationApiService.getReviewSummary(id),
      ]);
      setState(() {
        accommodation = results[0] as AccommodationDetail?;
        reviewSummary = results[1] as ReviewSummary?;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        accommodation = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (accommodation == null) return const Scaffold(body: Center(child: Text("숙소 정보를 찾을 수 없습니다.")));

    final data = accommodation!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccommodationImageSlider(
                  imageUrls: data.accommodationImages
                      .map((img) => img.accommodationImageUrl)
                      .where((url) => url.isNotEmpty)
                      .toList(),
                  initialIndex: 0,
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        TitleSection(name: data.accommodationName),
                        const CustomDivider(),
                        // DB 백엔드에서 숙소ID 조회한 숙소 평점, count(), 최신 리뷰 내용 불러오기
                        ReviewPreviewSection(
                          rating: reviewSummary?.averageRating.toString() ?? '0.0',
                          count: reviewSummary?.totalCount.toString() ?? '0',
                          desc: reviewSummary?.latestContent ?? '작성된 리뷰가 없습니다.',
                          onReviewTap: () {
                            context.push(
                              '${RoutePaths.accommodationReview}/${widget.accommodationId}',
                            );
                          },
                        ),
                        const CustomDivider(),
                        FacilitySection(labels: data.serviceLabels),
                        const CustomDivider(),
                        InfoSection(contact: data.accommodationPhone),
                        const CustomDivider(),
                        PolicySection(),
                        const CustomDivider(),
                        LocationSection(address: data.accommodationAddress, mapHeight: screenWidth * (2 / 5)),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: BottomActionButton(
              label: "모든 객실 보기",
              onPressed: () => context.push(RoutePaths.productList),
            ),
          ),
        ],
      ),
    );
  }
}