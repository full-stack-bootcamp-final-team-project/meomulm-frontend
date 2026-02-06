import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/paths/api_paths.dart';
import 'package:meomulm_frontend/features/my_page/data/models/select_favorite_model.dart';

class FavoriteService {
  // dio 인스턴스 셋팅
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.favoriteUrl, // /api/favorite
      connectTimeout: const Duration(seconds: 10), // 10초 타임아웃
      receiveTimeout: const Duration(seconds: 30), // 30초 타임아웃
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // 사용자 찜 목록 가져오기
  Future<List<SelectFavoriteModel>> getFavorites(String token) async {
    try {
      final response = await _dio.get(
        '',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data;
      print('data: $data');
      return data.map((json) => SelectFavoriteModel.fromJson(json)).toList();
    } catch (e) {
      print('찜 목록 조회 실패: $e');
      return [];
    }
  }

  // 사용자 찜 추가하기
  Future<bool> postFavorite(String token, int accommodationId) async {
    try {
      final response = await _dio.post(
        '/$accommodationId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('찜 추가 성공: accommodationId=$accommodationId');
      return true;
    } catch (e) {
      print('찜 추가 실패: $e');
      return false;
    }
  }


  // 사용자 찜 삭제하기
  Future<bool> deleteFavorite(String token, int favoriteId) async {
    try {
      final response = await _dio.delete(
        '/$favoriteId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return true;
    } catch (e) {
      print('찜 삭제 실패: $e');
      return false;
    }
  }
}