
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/features/accommodation/data/datasources/accommodation_api_service.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_detail_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/review_summary.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/customer_divider.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/facility_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/info_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/location_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/policy_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/review_preview_section.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_detail_widgets/title_section.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/accommodation_detail_widgets/accommodation_image_slider.dart';

class AccommodationDetailScreen extends StatefulWidget {
  final int accommodationId;
  const AccommodationDetailScreen({super.key, required this.accommodationId});

  @override
  State<AccommodationDetailScreen> createState() => _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {
  bool isLoading = true;
  AccommodationDetailModel? accommodation;
  ReviewSummaryModel? reviewSummary;
  bool isFavorite = false;


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

      // ========================= 최근 숙소 저장 =========================
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final token = context.read<AuthProvider>().token;

        // 비로그인 → 저장 안 함
        if (token == null || token.isEmpty) {
          debugPrint('비로그인 상태 → 최근 본 숙소 저장 안 함');
          return;
        }

        // 로그인 → 저장
        final homeProvider = context.read<HomeProvider>();
        await homeProvider.addRecentAccommodationId(
          widget.accommodationId,
          isLoggedIn: true,
        );

        await homeProvider.loadRecentFromLocal(
          isLoggedIn: true,
        );
      });
      // =================================================================

      setState(() {
        accommodation = results[0] as AccommodationDetailModel?;
        reviewSummary = results[1] as ReviewSummaryModel?;
        isLoading = false;

        if (accommodation != null) {
          context.read<AccommodationProvider>().setAccommodationInfo(
            id,
            accommodation!.accommodationName,
          );
        }
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
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (accommodation == null)
      return const Scaffold(body: Center(child: Text("숙소 정보를 찾을 수 없습니다.")));

    final data = accommodation!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
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
                    accommodationId: widget.accommodationId,
                    initialIndex: 0,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          TitleSection(name: data.accommodationName),
                          const CustomDivider(),
                          ReviewPreviewSection(
                            rating: reviewSummary?.averageRating.toString() ??
                                '0.0',
                            count: reviewSummary?.totalCount.toString() ?? '0',
                            desc: reviewSummary?.latestContent ??
                                '작성된 리뷰가 없습니다.',
                            onReviewTap: () =>
                                context.push(
                                    '${RoutePaths.accommodationReview}/${widget
                                        .accommodationId}'),
                          ),
                          const CustomDivider(),
                          FacilitySection(labels: data.serviceLabels),
                          const CustomDivider(),
                          InfoSection(contact: data.accommodationPhone),
                          const CustomDivider(),
                          PolicySection(),
                          const CustomDivider(),
                          LocationSection(
                              address: data.accommodationAddress,
                              mapHeight: screenWidth * (2 / 5),
                              latitude: data.accommodationLatitude,
                              longitude: data.accommodationLongitude
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomActionButton(
                label: "모든 객실 보기",
                onPressed: () => context.push(RoutePaths.productList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}