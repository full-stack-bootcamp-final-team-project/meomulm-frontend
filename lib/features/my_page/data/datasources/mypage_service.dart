import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/features/my_page/data/models/edit_profile_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/user_profile_model.dart';

class MypageService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: ApiPaths.userUrl,  // /api/users
        connectTimeout: const Duration(seconds: 10),  // 10초 타임아웃
        receiveTimeout: const Duration(seconds: 30),  // 30초 타임아웃
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

  /*
  프로필 이미지 저장
   */
  Future<void> uploadProfileImage(String token, String imageUrl) async {
    try {
      await _dio.patch(
        '/profileImage',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: imageUrl,
      );
    } on DioException catch (e) {
      print('프로필 이미지 저장 실패 - 상태코드: ${e.response?.statusCode}, $e');
      throw Exception('프로필 이미지 저장에 실패했습니다.');
    }
  }

  /*
  현재 비밀번호 확인
   */
  Future<bool> checkCurrentPassword(String token, String currentPassword) async{
    try {
      final response = await _dio.post(
        '/currentPassword',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {"currentPassword": currentPassword},
      );
      return true;
    } on DioException catch (e) {
      if(e.response?.statusCode == 404) {
        // 비밀번호 불일치
        return false;
      } else {
        print('비밀번호 확인 실패: $e');
        throw Exception('비밀번호 확인에 실패했습니다: 서버 에러');
      }
    }
  }

  /*
  비밀번호 수정
   */
  Future<bool> changePassword(String token, String newPassword) async {
    try {
      final response = await _dio.patch(
        '/password',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {"newPassword": newPassword},
      );
      return true;
    } catch (e) {
      print('비밀번호 수정 실패: $e');
      throw Exception('비밀번호 수정에 실패했습니다.');
    }
  }

  /*
  회원탈퇴
   */
  Future<bool> userWithdrawal(String token) async {
    try {
      final response = await _dio.delete(
        '',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } catch (e) {
      print('회원탈퇴 실패: $e');
      throw Exception('회원 탈퇴에 실패했습니다.');
    }
  }

}