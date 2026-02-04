import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/error/app_exception.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';

class MapService {
  // 싱글톤 패턴
  static final MapService _instance = MapService._internal();
  factory MapService() => _instance;

  late final Dio _dio;

  MapService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiPaths.accommodationUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
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

      debugPrint('📍 필터 적용 여부: $hasFilter');
      debugPrint('📦 필터 데이터: $filterParams');

      Response response;

      if (hasFilter) {
        // /search - GET 방식 (쿼리 파라미터)
        final queryParams = {
          'latitude': latitude,
          'longitude': longitude,
          ...filterParams,
        };

        debugPrint('🔍 GET /search 호출');
        debugPrint('📦 쿼리 파라미터: $queryParams');

        response = await _dio.get(
          '/search',
          queryParameters: queryParams,
        );
      } else {
        // /map - POST 방식 (JSON body)
        final requestData = {
          "latitude": latitude,
          "longitude": longitude,
        };

        debugPrint('🗺️ POST /map 호출');
        debugPrint('📦 요청 바디: $requestData');

        response = await _dio.post(
          '/map',
          data: requestData,
        );
      }

      // 성공 응답
      if (response.statusCode == 200) {
        if (response.data is List) {
          final List data = response.data;
          return data
              .map((json) => SearchAccommodationResponseModel.fromJson(json))
              .toList();
        }

        debugPrint('응답 데이터 형식 오류: ${response.data}');
        throw AppException(
          status: 200,
          code: 'INVALID_RESPONSE_FORMAT',
          message: '서버 응답 형식이 올바르지 않습니다.',
        );
      }

      if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        throw _parseErrorResponse(response);
      }

      debugPrint('예상치 못한 응답 코드: ${response.statusCode}');
      throw AppException(
        status: response.statusCode ?? 0,
        code: 'UNEXPECTED_RESPONSE',
        message: '서버 응답이 올바르지 않습니다.',
      );
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('숙소 검색 네트워크 에러: ${e.type} - ${e.message}');
      throw _parseDioException(e);
    } catch (e) {
      debugPrint('숙소 검색 에러: $e');
      throw AppException(
        status: 0,
        code: 'UNKNOWN_ERROR',
        message: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  /// 백엔드 에러 응답 파싱
  AppException _parseErrorResponse(Response response) {
    try {
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        return AppException(
          status: data['status'] ?? response.statusCode ?? 0,
          code: data['code'] ?? 'UNKNOWN_CODE',
          message: data['message'] ?? '알 수 없는 오류가 발생했습니다.',
        );
      }

      // JSON이 아닌 경우
      return AppException(
        status: response.statusCode ?? 0,
        code: 'PARSE_ERROR',
        message: '에러 응답을 처리할 수 없습니다.',
      );
    } catch (e) {
      debugPrint('에러 응답 파싱 실패: $e');
      return AppException(
        status: response.statusCode ?? 0,
        code: 'PARSE_ERROR',
        message: '에러 응답을 처리할 수 없습니다.',
      );
    }
  }

  /// DioException을 AppException으로 변환
  AppException _parseDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          status: 0,
          code: 'TIMEOUT',
          message: '요청 시간이 초과되었습니다.',
        );

      case DioExceptionType.connectionError:
        return AppException(
          status: 0,
          code: 'NETWORK_ERROR',
          message: '네트워크 연결을 확인해주세요.',
        );

      case DioExceptionType.badResponse:
      // 서버 응답이 있는 경우 파싱 시도
        if (e.response != null) {
          return _parseErrorResponse(e.response!);
        }
        return AppException(
          status: e.response?.statusCode ?? 0,
          code: 'BAD_RESPONSE',
          message: '서버 응답이 올바르지 않습니다.',
        );

      default:
        return AppException(
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