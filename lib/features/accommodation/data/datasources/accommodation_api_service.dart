import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_detail_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_review.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/review_summary.dart';

class AccommodationApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.accommodationUrl,
      connectTimeout : const Duration(seconds: 10),
      receiveTimeout : const Duration(seconds: 10),
      headers:{
        'Content-Type' : 'application/json',
      },
    ),
  );

  static Future<List<SearchAccommodationResponseModel>> getAccommodationByKeyword({
    required String keyword,    // 사용자가 검색한 숙소명/지역
  }) async {
    try {
      final res = await _dio.get(
        '/keyword',
        queryParameters: {
          'keyword': keyword
        },
      );
      if (res.statusCode == 200) {
        final List<dynamic> jsonList = res.data;
        // return jsonList.map((json) =>
        //     Accommodation.fromJson(json)).toList();
        return jsonList.map((json) {
          // [확인] 각 숙소 데이터가 들어올 때 이미지가 어떻게 생겼는지 출력
          // print('숙소명: ${json['accommodationName']} / 이미지데이터: ${json['accommodationImages']}');

          return SearchAccommodationResponseModel.fromJson(json);
        }).toList();
      } else if (res.statusCode == 404) {
        return [];
      } else {
        throw Exception('서버 오류: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('알 수 없는 오류: $e');
    }
  }

  static Future<AccommodationDetail?> getAccommodationById(int accommodationId) async {
    try{
      final res = await _dio.get('/detail/${accommodationId}');
      if (res.statusCode == 200) {
        return AccommodationDetail.fromJson(res.data);
      } else if (res.statusCode == 404) {
        return null;
      } else {
        throw Exception('서버 오류: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('알 수 없는 오류: $e');
    }
  }

  static Future<ReviewSummary?> getReviewSummary(int accommodationId) async {
    try {
      final res = await _dio.get('/reviews/summary/${accommodationId}');

      if (res.statusCode == 200) {
        return ReviewSummary.fromJson(res.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('리뷰 요약 로드 실패: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('알 수 없는 리뷰 에러: $e');
      return null;
    }
  }

  static Future<List<AccommodationReview>> getReviewsByAccommodationId(int id) async {
    try {
      // 백엔드 엔드포인트: @GetMapping("/accommodationId/{accommodationId}")
      final res = await _dio.get('/reviews/accommodationId/$id');
      if (res.statusCode == 200) {
        return (res.data as List)
            .map((json) => AccommodationReview.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('리뷰 목록 로드 실패: $e');
      return [];
    }
  }
}