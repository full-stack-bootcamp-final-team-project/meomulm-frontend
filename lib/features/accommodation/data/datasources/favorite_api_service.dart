import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';


class FavoriteApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.favoriteUrl,
      connectTimeout : const Duration(seconds: 10),
      receiveTimeout : const Duration(seconds: 30),
      headers:{
        'Content-Type' : 'application/json',
      },
    ),
  );

  // 찜 조회
  static Future<int> getFavorite(
      String token,
      int accommodationId,
      ) async {
    final res = await _dio.get(
      '/accommodation',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
      queryParameters: {
        'accommodationId': accommodationId,
      },
    );

    if (res.statusCode == 200) {
      return res.data;
    } else {
      throw Exception('찜 조회 실패');
    }
  }


  // 찜 추가
  static Future<void> postFavorite(
      String token,
      int accommodationId,
      ) async {
    final res = await _dio.post(
      '/$accommodationId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),

    );

    if (res.statusCode == 200) {
      return ;
    } else {
      throw Exception('찜 조회 실패');
    }
  }


  // 찜 삭제
  static Future<void> deleteFavorite(
      String token,
      int favoriteId,
      ) async {
    final res = await _dio.delete(
      '/$favoriteId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),

    );

    if (res.statusCode == 200) {
      return ;
    } else {
      throw Exception('찜 조회 실패');
    }
  }
}



