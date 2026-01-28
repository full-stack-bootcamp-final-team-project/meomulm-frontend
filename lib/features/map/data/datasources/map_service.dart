import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/map/data/models/accommodation.dart';

class MapService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.accommodationUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );
  // 위도/경도 기반 5km 반경 검색
  Future<List<Accommodation>> getAccommodationByLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post(
        '/map',
        data: {
          "latitude": latitude,
          "longitude": longitude,
        },

    );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Accommodation.fromJson(json)).toList();
      }
      if (response.statusCode == 404) {
        return [];
      }
      return [];
    } catch (e) {
      debugPrint('숙소 검색 에러: $e');
      rethrow;
    }
  }
}