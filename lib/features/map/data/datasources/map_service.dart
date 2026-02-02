import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class MapService {
  final Dio _dio = Dio(
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

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List data = response.data;
          return data
              .map((json) => SearchAccommodationResponseModel.fromJson(json))
              .toList();
        }
        debugPrint('응답 데이터 형식 오류: ${response.data}');
        return [];
      }

      if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
        debugPrint('클라이언트 에러 [${response.statusCode}]: ${response.data}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: '요청이 잘못되었습니다.',
        );
      }

      debugPrint('예상치 못한 응답 코드: ${response.statusCode}');
      return [];

    } on DioException catch (e) {
      debugPrint('숙소 검색 네트워크 에러: ${e.type} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('숙소 검색 에러: $e');
      rethrow;
    }
  }

  void dispose() {
    _dio.close();
  }
}