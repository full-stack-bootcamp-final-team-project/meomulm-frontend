import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/error/app_exception.dart';
import 'package:meomulm_frontend/core/error/error_parser.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

/// 위치 좌표 기반 숙소 검색 API 통신을 담당하는 서비스
class MapService {
  static final MapService _instance = MapService._internal();

  factory MapService() => _instance;

  late final Dio _dio;

  MapService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiPaths.accommodationUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );
  }

  /// 위도/경도로 숙소 검색 (필터 적용 여부에 따라 엔드포인트 분기)
  Future<List<SearchAccommodationResponseModel>> getAccommodationByLocation({
    required double latitude,
    required double longitude,
    Map<String, dynamic>? filterParams,
  }) async {
    try {
      // 필터가 있으면 /search (GET), 없으면 /map (POST) 사용
      final hasFilter = filterParams != null && filterParams.isNotEmpty;
      Response response;

      if (hasFilter) {
        final queryParams = {
          'latitude': latitude,
          'longitude': longitude,
          ...filterParams,
        };

        response = await _dio.get('/search', queryParameters: queryParams);
      } else {
        final requestData = {"latitude": latitude, "longitude": longitude};

        response = await _dio.post('/map', data: requestData);
      }

      // 성공 응답
      if (response.statusCode == 200) {
        if (response.data is List) {
          final List data = response.data;
          return data
              .map((json) => SearchAccommodationResponseModel.fromJson(json))
              .toList();
        }

        throw AppException(
          status: 200,
          code: 'INVALID_RESPONSE_FORMAT',
          message: '서버 응답 형식이 올바르지 않습니다.',
        );
      }

      if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! <= 500) {
        throw ErrorParser.parseErrorResponse(response);
      }

      throw AppException(
        status: response.statusCode ?? 0,
        code: 'UNEXPECTED_RESPONSE',
        message: '서버 응답이 올바르지 않습니다.',
      );
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('숙소 검색 네트워크 에러: ${e.type} - ${e.message}');
      throw ErrorParser.parseDioException(e);
    } catch (e) {
      debugPrint('숙소 검색 에러: $e');
      throw AppException(
        status: 0,
        code: 'UNKNOWN_ERROR',
        message: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  void dispose() {
    _dio.close();
  }
}
