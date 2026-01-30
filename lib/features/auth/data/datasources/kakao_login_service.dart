import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';

class KakaoLoginService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.authUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // 카카오 로그인 전체 플로우
  Future<Map<String, dynamic>> loginWithKakao() async {
    try {
      // 1. 카카오 계정으로 로그인 (카카오톡 우회)
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

      print('카카오 로그인 성공');

      // 2. 백엔드로 액세스 토큰 전송
      return await sendTokenToBackend(token.accessToken);

    } catch (error) {
      print('카카오 로그인 실패: $error');
      rethrow;
    }
  }

  // 백엔드로 카카오 액세스 토큰 전송
  Future<Map<String, dynamic>> sendTokenToBackend(String accessToken) async {
    try {
      print('📤 POST ${_dio.options.baseUrl}/kakao');
      print('📤 accessToken 길이: ${accessToken.length}자');

      final response = await _dio.post(
        '/kakao/token',  // ← 경로 변경!
        data: {'accessToken': accessToken},
      );

      print('📥 응답 코드: ${response.statusCode}');
      print('📥 응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ 백엔드 인증 성공');
        return response.data;
      } else {
        throw Exception('백엔드 로그인 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException 발생!');
      print('   타입: ${e.type}');
      print('   메시지: ${e.message}');

      if (e.response != null) {
        print('   응답 코드: ${e.response?.statusCode}');
        print('   응답 데이터: ${e.response?.data}');
      } else {
        print('   응답 없음 (네트워크 문제 가능성)');
      }

      rethrow;
    } catch (e) {
      print('❌ 일반 예외 발생: $e');
      rethrow;
    }
  }

  // 카카오 사용자 정보 조회 (필요시)
  Future<User> getKakaoUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('카카오 사용자 정보:');
      print('닉네임: ${user.kakaoAccount?.profile?.nickname}');
      print('이메일: ${user.kakaoAccount?.email}');
      return user;
    } catch (error) {
      print('사용자 정보 조회 실패: $error');
      rethrow;
    }
  }
}