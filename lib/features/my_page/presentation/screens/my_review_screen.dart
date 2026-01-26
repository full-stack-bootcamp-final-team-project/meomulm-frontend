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
import 'package:meomulm_frontend/features/my_page/data/models/review_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review/review_card.dart';

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
  final List<ReviewModel> _reviews = [
    ReviewModel(
      hotelName: '롯데 호텔 명동',
      dateText: '2025.12.31',
      rating: 4.0,
      content: '방 컨디션이 매우 좋았습니다!\n재방문 의사 있습니다(단, 추워요)',
    ),
    ReviewModel(
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
              return ReviewCard(
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