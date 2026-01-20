
import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';

class AuthService {
  static final String url = ApiPaths.authUrl;

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<LoginResponse> login(String userEmail, String userPassword) async {
    final loginRequest = LoginRequest(
      userEmail: userEmail,
      userPassword: userPassword,
    );

    try {
      final res = await _dio.post(
        ApiPaths.loginUrl,
        data: loginRequest.toJson(),
      );

      if (res.statusCode == 200) {
        return LoginResponse.fromJson(res.data);
      } else {
        throw Exception('로그인 실패: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('로그인 실패: ${e.response?.statusMessage}');
      } else {
        throw Exception('네트워크 오류: ${e.message}');
      }
    }
  }

  static Future<void> signup({
    required String userEmail,
    required String userPassword,
    required String userName,
    String? userPhone,
    String? userBirth,
  }) async {
    final signupRequest = SignupRequest(
      userEmail: userEmail,
      userPassword: userPassword,
      userName: userName,
      userPhone: userPhone,
      userBirth: userBirth,
    );

    try {
      final res = await _dio.post(
        ApiPaths.signupUrl,
        data: signupRequest.toJson(),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception('회원가입 실패: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('회원가입 실패: ${e.response?.statusMessage}');
      } else {
        throw Exception('네트워크 오류: ${e.message}');
      }
    }
  }



}