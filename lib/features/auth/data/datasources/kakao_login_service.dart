import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/config/env_config.dart';

class KakaoLoginService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> sendTokenToBackend(String accessToken) async {
    try {
      print('📤 백엔드로 액세스 토큰 전송');
      print('   토큰 앞 20자: ${accessToken.substring(0, 20)}...');
      print('   API URL: ${EnvConfig.apiBaseUrl}/auth/kakao');

      final response = await _dio.post(
        '/auth/kakao',
        data: {'accessToken': accessToken},
      );

      print('📥 백엔드 응답 수신');
      print('   상태 코드: ${response.statusCode}');
      print('   응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        // 로그인 성공
        return response.data;
      } else if (response.statusCode == 202) {
        // 미가입 회원
        return response.data;
      } else {
        throw Exception('예상치 못한 응답: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException 발생');
      if (e.response != null) {
        print('   서버 에러: ${e.response?.statusCode}');
        print('   에러 메시지: ${e.response?.data}');
        throw Exception('서버 에러: ${e.response?.data}');
      } else {
        print('   네트워크 에러: ${e.message}');
        throw Exception('네트워크 에러: 서버에 연결할 수 없습니다.');
      }
    } catch (e) {
      print('❌ 기타 에러: $e');
      rethrow;
    }
  }
}