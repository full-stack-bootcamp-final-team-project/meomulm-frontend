import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class HomeAccommodationService {
  // dio 인스턴스 셋팅
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.accommodationUrl, // /api/accommodation
      connectTimeout: const Duration(seconds: 20), // 20초 타임아웃
      receiveTimeout: const Duration(seconds: 30), // 30초 타임아웃
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // 숙소 HOT
  Future<List<SearchAccommodationResponseModel>> getAccommodationPopularByAddress(String accommodationAddress) async {
    try {
      final response = await _dio.get(
        '/popular',
        queryParameters: {
          'accommodationAddress': accommodationAddress,
        },
      );
      final List<dynamic> data = response.data;
      return data.map((json) => SearchAccommodationResponseModel.fromJson(json)).toList();
    } catch(e) {
      debugPrint('HOT $accommodationAddress 숙소 목록 로드 실패: $e');
      return [];
    }
  }
}