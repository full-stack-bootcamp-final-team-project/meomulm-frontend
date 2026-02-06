import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/core/error/app_exception.dart';
import 'package:meomulm_frontend/core/error/error_parser.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_response_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/review_response_model.dart';

class ReviewService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.reviewUrl,  // /api/review
      connectTimeout: const Duration(seconds: 10),  // 10초 타임아웃
      receiveTimeout: const Duration(seconds: 30),  // 30초 타임아웃
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

      // 성공 응답
      if(response.statusCode == 200) {
        return true;
      }

      if(response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! <= 500) {
        throw ErrorParser.parseErrorResponse(response);
      }

      throw AppException(
        status: response.statusCode ?? 0,
        code: 'UNEXPECTED_RESPONSE',
        message: '서버 응답이 올바르지 않습니다.',
      );
      // return false;
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('숙소 검색 네트워크 에러: ${e.type} - ${e.message}');
      debugPrint('DioException data: ${e.response?.data}');
      throw ErrorParser.parseDioException(e);
    } catch (e) {
      print('리뷰 삭제 실패: $e');
      throw AppException(
        status: 0,
        code: 'UNKNOWN_ERROR',
        message: '알 수 없는 오류가 발생했습니다.',
      );
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