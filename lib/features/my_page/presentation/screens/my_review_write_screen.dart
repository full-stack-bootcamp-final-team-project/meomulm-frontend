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
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/core/widgets/layouts/star_rating_widget.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review_write/rating_row.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review_write/reservation_info_card.dart';

/*
 * 마이페이지 - 리뷰 작성 스크린 - only_app_style : 수정 필요.
 */
class MyReviewWriteScreen extends StatefulWidget {
  const MyReviewWriteScreen({super.key});

  @override
  State<MyReviewWriteScreen> createState() => _MyReviewWriteScreenState();
}

class _MyReviewWriteScreenState extends State<MyReviewWriteScreen> {
  double _rating = 0.0; // 0.0 ~ 5.0 (0.5 step)
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _ratingFromDx(double dx, double width) {
    final clamped = dx.clamp(0.0, width);
    final raw = (clamped / width) * 5.0; // 0~5
    final stepped = (raw * 2).round() / 2; // 0.5 단위
    return stepped.clamp(0.0, 5.0);
  }

  void _onSubmit() {
    // TODO: 실제 리뷰 등록 API 호출/검증 로직 추가 (필요 시)
    // 예) await reviewService.createReview(...);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(SnackBarMessages.reviewSubmitted),
        behavior: SnackBarBehavior.floating,
        duration: AppDurations.snackbar,
      ),
    );

    // TODO: push/pop 중 하나로 결정
    // context.push('${RoutePaths.myPage}${RoutePaths.myReview}');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final maxWidth = w >= 600 ? 520.0 : double.infinity;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: TitleLabels.writeReview),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // 상단 예약 정보 카드
                  ReservationInfoCard(),

                  const SizedBox(height: AppSpacing.xl),

                  // TODO: star_rating_widget은 별점 선택이 불가해서 별도 위젯 생성함.
                  RatingRow(
                    rating: _rating,
                    onChanged: (v) => setState(() => _rating = v),
                    ratingFromDx: _ratingFromDx,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 리뷰 입력 박스
                  Expanded(
                    child: Container(
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
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 등록 버튼
                  LargeButton(
                      label: ButtonLabels.register, 
                      onPressed: () {
                        // TODO: 버튼 클릭 시 백엔드 연결하는 함수 구현
                        // TODO: 백엔드 응답 ok(200)일 때 나의 리뷰 스크린으로 이동
                        // TODO: 등록 완료 시 SnackBar 띄우기
                      }, 
                      enabled: false // TODO: 별점 등록 및 리뷰 입력 시 true 로 변경하는 함수 구현 후 호출
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}