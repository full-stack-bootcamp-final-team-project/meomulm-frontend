import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
class MapService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.accommodationUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<List<SearchAccommodationResponseModel>> getAccommodationByLocation({
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

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data
            .map((json) => SearchAccommodationResponseModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('숙소 검색 에러: $e');
      rethrow;
    }
  }
}
