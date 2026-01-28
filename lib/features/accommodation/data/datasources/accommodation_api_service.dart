import 'package:dio/dio.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/accommodation_model.dart';

class AccommodationApiService {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.accommodationUrl,
      connectTimeout : const Duration(seconds: 5),
      receiveTimeout : const Duration(seconds: 3),
      headers:{
        'Content-Type' : 'application/json',
      },
    ),
  );

  static Future<List<Accommodation>> getAccommodationByKeyword({
        required String keyword,    // 사용자가 검색한 숙소명/지역
      }) async {
    try {
      final res = await _dio.get(
        '/keyword',
        queryParameters: {
          'keyword': keyword
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> jsonList = res.data;
        return jsonList.map((json) =>
            Accommodation.fromJson(json)).toList();
      } else if (res.statusCode == 404) {
        return [];
      } else {
        throw Exception('서버 오류: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('알 수 없는 오류: $e');
    }
  }
}