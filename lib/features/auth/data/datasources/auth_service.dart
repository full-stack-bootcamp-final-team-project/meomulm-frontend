import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/auth/data/models/change_password_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';

class AuthService {
  static final String url = ApiPaths.authUrl;

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );



  // 로그인
  static Future<LoginResponseModel> login(String userEmail, String userPassword) async {
    final loginRequest = LoginRequestModel(
      userEmail: userEmail,
      userPassword: userPassword,
    );

    try {
      final res = await _dio.post(
        ApiPaths.loginUrl,
        data: loginRequest.toJson(),
      );

      if (res.statusCode == 200) {
        return LoginResponseModel.fromJson(res.data);
      } else {
        print("로그인 실패");
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

  // 회원가입
  static Future<void> signup({
    required String userEmail,
    required String userPassword,
    required String userName,
    String? userPhone,
    String? userBirth,
  }) async {
    final signupRequest = SignupRequestModel(
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

  // 아이디 중복 확인
  static Future<bool> checkEmailDuplicate(String userEmail) async {
    try {
      final res = await _dio.get(
        '${ApiPaths.authUrl}/checkEmail',
        queryParameters: {'email': userEmail},
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception('이메일 중복 확인 실패 : $e');
    }
  }

  // 전화번호 중복 확인
  static Future<bool> checkPhoneDuplicate(String userPhone) async {
    try {
      final res = await _dio.get(
        '${ApiPaths.authUrl}/checkPhone',
        queryParameters: {'phone': userPhone},
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception('전화번호 중복 확인 실패 : $e');
    }
  }

  // 아이디 찾기
  static Future<String?> userEmailCheck(String userName, String userPhone) async {
    try {
      final res = await _dio.get(
          '${ApiPaths.findIdUrl}',
          queryParameters: {
            'userName': userName,
            'userPhone': userPhone
          }
      );
      return res.data?.toString();

    } catch(e) {
      print("이메일 조회 실패 $e");
      return null;
    }
  }

  // 본인 인증
  static Future<int?> confirmPassword(String userEmail, String userBirth) async {
    try {
      final res = await _dio.get(
          '${ApiPaths.confirmPasswordUrl}',
          queryParameters: {
            'userEmail': userEmail,
            'userBirth': userBirth
          }
      );

      if(res.data != null){
        return res.data;
      } else {
        return null;
      }

    } catch(e) {
      print("본인 인증 실패 $e");
      return null;
    }
  }

  // 비밀번호 변경 (로그인)
  static Future<int?> LoginChangePassword(int userId, String userPassword) async {
    final changePassword = ChangePasswordModel(
      userId: userId,
      userPassword: userPassword,
    );

    try {
      final res = await _dio.patch(
          '${ApiPaths.loginChangePasswordUrl}',
          data: changePassword.toJson()
      );

      if(res.statusCode == 200){
        return 1;
      } else {
        return 0;
      }

    } catch(e) {
      print("비밀번호 변경 실패 $e");
      return null;
    }
  }
}