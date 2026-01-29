import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/features/my_page/data/models/edit_profile_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/user_profile_model.dart';

class MypageService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: ApiPaths.userUrl,  // /api/users
        connectTimeout: const Duration(seconds: 5),  // 5초 타임아웃
        receiveTimeout: const Duration(seconds: 3),  // 3초 타임아웃
        headers: {
          'Content-Type': 'application/json',
        },
      ),
  );

  /*
  유저 정보 조회
   */
  Future<UserProfileModel> loadUserProfile(String token) async {
    try {
      final response = await _dio.get(
        '',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final Map<String, dynamic> json = response.data;
      return UserProfileModel.fromJson(json);
    } catch (e) {
      print('회원정보 조회 실패: $e');
      throw Exception('회원정보를 불러올 수 없습니다.');
    }
  }

  // TODO: 이미지 업로드/수정 fetch 함수

  /*
  회원정보 수정
   */
  Future<bool> uploadEditProfile(String token, EditProfileRequestModel user) async {
    try {
      final response = await _dio.put(
        '/userInfo',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: user.toJson(),
      );
      return true;
    } catch (e) {
      print('회원정보 수정 실패: $e');
      throw Exception('회원정보 수정에 실패했습니다.');
    }
  }

}