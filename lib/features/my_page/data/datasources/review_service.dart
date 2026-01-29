import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_response_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_response_model.dart';

class ReviewService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.reviewUrl,  // /api/review
      connectTimeout: const Duration(seconds: 5),  // 5초 타임아웃
      receiveTimeout: const Duration(seconds: 3),  // 3초 타임아웃
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /*
  리뷰 조회
   */
  Future<List<ReviewResponseModel>> loadReviews(String token) async {
    try {
      final response = await _dio.get(
          '',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<dynamic> data = response.data;
      return data.map((json) => ReviewResponseModel.fromJson(json)).toList();
    } catch (e) {
      print('리뷰 조회 실패: $e');
      throw Exception('리뷰를 조회할 수 없습니다.');
    }
  }

  /*
  리뷰 작성
   */
  Future<bool> uploadReview(String token, ReviewRequestModel review) async {
    try {
      final response = await _dio.post(
          '',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: review.toJson(),
      );
      return true;
    } catch (e) {
      print('리뷰 등록 실패: $e');
      throw Exception('리뷰 등록에 실패했습니다.');
    }
  }

  /*
  리뷰 삭제
   */
  Future<bool> deleteReview(String token, int reviewId) async {
    try {
      final response = await _dio.delete(
          '/$reviewId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } catch (e) {
      print('리뷰 삭제 실패: $e');
      throw Exception('리뷰 삭제에 실패했습니다.');
    }
  }
}