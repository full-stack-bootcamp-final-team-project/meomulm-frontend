import 'package:dio/dio.dart';
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
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/review_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_response_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/review_provider.dart';
import 'package:meomulm_frontend/features/my_page/presentation/widgets/my_review/review_card.dart';
import 'package:provider/provider.dart';

/*
 * 마이페이지 - 내 리뷰 스크린 - only_app_style : 수정 필요.
 */
class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  List<ReviewResponseModel> reviews = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadReviews();
  }

  // 리뷰 조회
  Future<void> loadReviews() async {
    setState(() => isLoading = true);
    
    try {
      final reviewService = ReviewService();
      final token = context.read<AuthProvider>().token;
      if(token == null) {
        return;
      }
      final result = await reviewService.loadReviews(token);
      setState(() {
        reviews = result;
        isLoading = false;
      });
    } on DioException catch (e) {
      if(e.response?.statusCode == 404) {
        return;
      }
      // TODO: 공통 에러 페이지가 있으면 교체
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 리뷰 삭제
  Future<void> deleteReviews(int reviewId) async {
    setState(() => isLoading = true);

    try {
      final reviewService = ReviewService();
      final token = context.read<AuthProvider>().token;
      if(token == null) {
        // TODO: 로그인 만료 처리
        return;
      }
      final result = await reviewService.deleteReview(token, reviewId);
      if(result && mounted) {
        context.read<ReviewProvider>().removeReview(reviewId);
      }
    } catch (e) {
      // TODO: 공통 에러 페이지가 있으면 교체
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 리뷰 삭제 다이얼로그
  Future<void> _confirmDelete(int index) async {
    final reviewId = reviews[index].reviewId;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleModal(
          onConfirm: () async {
            await deleteReviews(reviewId);
            context.pop(true);
          },
          content: Text(DialogMessages.deleteReview),
          confirmLabel: ButtonLabels.confirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: TitleLabels.myReviews),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: reviews.isEmpty
              ? ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 24),
              Text(
                '작성한 리뷰가 없습니다.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.gray2)
              ),
            ],
          )
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = reviews[index];
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