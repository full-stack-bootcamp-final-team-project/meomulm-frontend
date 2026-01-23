import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/simple_modal.dart';
import 'package:meomulm_frontend/core/widgets/layouts/star_rating_widget.dart';

/*
 * 마이페이지 - 내 리뷰 스크린 - only_app_style : 수정 필요.
 */
class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  // TODO: 더미 데이터 - API 연동 시 이 리스트 교체
  final List<_ReviewItem> _reviews = [
    _ReviewItem(
      hotelName: '롯데 호텔 명동',
      dateText: '2025.12.31',
      rating: 4.0,
      content: '방 컨디션이 매우 좋았습니다!\n재방문 의사 있습니다(단, 추워요)',
    ),
    _ReviewItem(
      hotelName: '신라스테이 역삼',
      dateText: '2025.12.22',
      rating: 3.0,
      content: '방은 깨끗해요. 다만 살짝 습한 감이요',
    ),
  ];

  // 리뷰 삭제 다이얼로그
  Future<void> _confirmDelete(int index) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleModal(
            onConfirm: () {
              // TODO: 리뷰 삭제 로직 구현
            },
            content: Text(DialogMessages.deleteReview),
            confirmLabel: ButtonLabels.confirm,
        );
      },
    );

    if (result == true) {
      setState(() {
        _reviews.removeAt(index);
      });

      // TODO: 서버에 삭제 요청(API) 연결
      // 예) await reviewService.deleteReview(_reviews[index].reviewId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final maxWidth = w >= 600 ? 520.0 : double.infinity;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: TitleLabels.myReviews),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _reviews.isEmpty
              ? ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              SizedBox(height: 24),
              Text(
                '작성한 리뷰가 없습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8B8B8B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _reviews[index];
              return _ReviewCard(
                item: item,
                onDeleteTap: () => _confirmDelete(index),
              );
            },
          ),
        ),
      ),
    );
  }
}


/// ===============================
/// 카드 UI (쓰레기통 아이콘만 클릭 가능)
/// TODO: 위젯 분리
/// ===============================
class _ReviewCard extends StatelessWidget {
  final _ReviewItem item;
  final VoidCallback onDeleteTap;

  const _ReviewCard({
    required this.item,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppCardStyles.card,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 숙소명 + 삭제 아이콘
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                      item.hotelName,
                      style: AppTextStyles.cardTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                ),
                Material(
                  child: InkWell(
                    onTap: onDeleteTap,  // TODO: 아이콘 삭제 시 삭제되는 기능 구현 후 호출
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    hoverColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                    highlightColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                    splashColor: AppColors.cancelledLight.withValues(alpha: 0.3),
                    child: const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Icon(
                        AppIcons.delete,
                        size: AppIcons.sizeSm,
                        color: AppColors.cancelled,
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            // 날짜 + 별점
            Row(
              children: [
                Text(
                  item.dateText,
                  style: AppTextStyles.inputPlaceholder.copyWith(color: AppColors.gray2)
                ),
                const SizedBox(width: AppSpacing.sm),
                StarRatingWidget(rating: item.rating),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // 리뷰 내용
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.gray5,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Text(
                item.content,
                style: AppTextStyles.inputTextMd.copyWith(height: 1.35),
              ),
            ),
          ],
        )
      ),
    );
  }
}

/// ===============================
/// 데이터 모델 (더미)
/// TODO: /models/review_model.dart 로 분리하기
/// ===============================
class _ReviewItem {
  final String hotelName;
  final String dateText;
  final double rating;
  final String content;

  const _ReviewItem({
    required this.hotelName,
    required this.dateText,
    required this.rating,
    required this.content,
  });
}