import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';

class EditProfileService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.authUrl,  // /api/auth
      connectTimeout: const Duration(seconds: 10),  // 10초 타임아웃
      receiveTimeout: const Duration(seconds: 30),  // 30초 타임아웃
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /*
  연락처 중복 확인
   */
  Future<bool> checkPhoneDuplicate(String userPhone) async {
    try {
      final res = await _dio.get(
        '/checkPhone',
        queryParameters: {'phone': userPhone},
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception('전화번호 중복 확인 실패 : $e');
    }
  }
}