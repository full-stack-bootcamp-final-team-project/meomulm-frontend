import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meomulm_frontend/core/error/app_exception.dart';

class ErrorParser {
  /// 백엔드 에러 응답 파싱
  static AppException parseErrorResponse(Response response) {
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
  static AppException parseDioException(DioException e) {
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
          return parseErrorResponse(e.response!);
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
}