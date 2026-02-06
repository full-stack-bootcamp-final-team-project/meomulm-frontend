import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_icons.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/core/widgets/layouts/star_rating_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/review_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_request_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review_write/rating_row.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review_write/reservation_info_card.dart';
import 'package:provider/provider.dart';

/*
 * 마이페이지 - 리뷰 작성 스크린 - only_app_style : 수정 필요.
 */
class MyReviewWriteScreen extends StatefulWidget {
  final ReservationShareModel reservationShare;

  const MyReviewWriteScreen({super.key, required this.reservationShare});

  @override
  State<MyReviewWriteScreen> createState() => _MyReviewWriteScreenState();
}

class _MyReviewWriteScreenState extends State<MyReviewWriteScreen> {
  bool isLoading = false;
  bool _canSubmit = false;

  double _rating = 0.0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(_recalc);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 제출 가능여부 확인
  void _recalc() {
    final isSubmittable = _rating != 0.0 && _controller.text.trim().isNotEmpty;

    if (isSubmittable != _canSubmit) {
      setState(() => _canSubmit = isSubmittable);
    }
  }

  double _ratingFromDx(double dx, double width) {
    final clamped = dx.clamp(0.0, width);
    final raw = (clamped / width) * 5.0; // 0~5
    final stepped = (raw * 2).round() / 2; // 0.5 단위
    return stepped.clamp(0.0, 5.0);
  }

  // 제출 함수
  Future<void> _onSubmit() async {
    if (!_canSubmit) return;

    setState(() => isLoading = true);

    final rating = (_rating * 2).toInt();
    final reviewContent = _controller.text.trim();

    final request = ReviewRequestModel(
      accommodationId: widget.reservationShare.accommodationId,
      rating: rating,
      reviewContent: reviewContent,
    );

    try {
      final reviewService = ReviewService();
      final token = context.read<AuthProvider>().token;
      if (token == null) {
        return;
      }
      final result = await reviewService.uploadReview(token, request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(SnackBarMessages.reviewSubmitted),
          behavior: SnackBarBehavior.floating,
          duration: AppDurations.snackbar,
        ),
      );
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("리뷰 등록에 실패했습니다.")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: TitleLabels.writeReview),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
              ),
              children: [
                // 상단 예약 정보 카드
                ReservationInfoCard(reservationShare: widget.reservationShare),

                const SizedBox(height: AppSpacing.xl),

                RatingRow(
                  rating: _rating,
                  onChanged: (v) {
                    setState(() => _rating = v);
                    _recalc();
                  },
                  ratingFromDx: _ratingFromDx,
                ),

                const SizedBox(height: AppSpacing.md),

                Container(
                  height: 180,
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gray3),
                    borderRadius: AppBorderRadius.mediumRadius,
                    color: AppColors.white,
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: '리뷰를 입력하세요.',
                      hintStyle: AppTextStyles.inputPlaceholder,
                    ),
                    style: AppTextStyles.inputTextMd.copyWith(height: 1.35),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),

        bottomNavigationBar: AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: AppDurations.slow,
          curve: Curves.easeOut,
          child: SafeArea(
              child: SizedBox(
                height: 100,
                child: BottomActionButton(
                  label: ButtonLabels.register,
                  onPressed: _canSubmit ? _onSubmit : null,
                ),
              )
          ),
        )
    );
  }
}
