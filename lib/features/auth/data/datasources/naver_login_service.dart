import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart'; // baseUrl 같은 것

class NaverLoginService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.authUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> sendTokenToBackend(String accessToken) async {
    final res = await _dio.post('/naver', data: {'accessToken': accessToken});
    return Map<String, dynamic>.from(res.data);
  }
}
