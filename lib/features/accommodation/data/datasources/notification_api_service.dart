import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_detail_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/notification_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_review_model.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/review_summary.dart';

class NotificationApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.notificationUrl,
      connectTimeout : const Duration(seconds: 10),
      receiveTimeout : const Duration(seconds: 30),
      headers:{
        'Content-Type' : 'application/json',
      },
    ),
  );

  // 토큰 전역 변수
  static String? _authToken;

  // 외부에서 Token을 동적으로 세팅 (앱 구동 시나 로그인 시 호출)
  static void setupInterceptors(String token) {
    _authToken = token; // 나중에 꺼내 쓸 수 있도록 저장
    _dio.interceptors.clear(); // 기존 인터셉터 중복 방지
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  static Future<List<NotificationResponseModel>> getNotifications({
    required String token
  }) async {
    try {
      final res = await _dio.get(
        '/list',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (res.statusCode == 200) {
        final List<dynamic> jsonList = res.data;
        return jsonList.map((json) =>
            NotificationResponseModel.fromJson(json)).toList();
      } else if (res.statusCode == 404) {
        return [];
      } else {
        throw Exception('서버 오류: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('알 수 없는 오류: $e');
    }
  }


  static Future<void> updateNotificationStatus({
    required int notificationId,
    // required String token,
  }) async {
    try {
      final res = await _dio.patch(
        '/list/$notificationId',
        // options: Options(headers: {
        //   'Authorization': 'Bearer $token',
        // }),
      );

      if (res.statusCode != 200) {
        throw Exception('수정 실패: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('수정 중 오류 발생: ${e.message}');
    }
  }

  static Future<void> deleteNotification({
    required int notificationId,
  }) async {
    try {
      final res = await _dio.delete(
        '/list/$notificationId',
        // options: Options(headers: {
        //   'Authorization': 'Bearer $token',
        // }),
      );

      if (res.statusCode != 200) {
        throw Exception('삭제 실패: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('삭제 중 오류 발생: ${e.message}');
    }
  }
}